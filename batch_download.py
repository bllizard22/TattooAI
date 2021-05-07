"""
This a file for batch downloading files
from Firebase Storage
"""

import os
import datetime
import requests
from firebase_admin import storage


PROJECT_ID = 'firephotos-40d70'
IS_EXTERNAL_PLATFORM = True  # False if using Cloud Functions
firebase_app = None


def init_firebase():
    global firebase_app
    if firebase_app:
        return firebase_app

    import firebase_admin
    from firebase_admin import credentials

    if IS_EXTERNAL_PLATFORM:
        cred = credentials.Certificate('firephotos-40d70-firebase-adminsdk-g8g4q-8cfd3ce72b.json')
    else:
        cred = credentials.ApplicationDefault()

    firebase_app = firebase_admin.initialize_app(cred, {
        # 'projectId': PROJECT_ID,
        'storageBucket': f"{PROJECT_ID}.appspot.com"
    })

    return firebase_app


def get_url_by_name(name):
    _blob = bucket.blob(name)
    path = _blob.generate_signed_url(datetime.timedelta(minutes=5), method='GET')
    return path


def download_image(url, _dir, file):
    req = requests.get(url)
    with open(_dir + file, 'wb') as image:
        image.write(req.content)


def save_image(server_path, local_dir, name):
    image_url = get_url_by_name(server_path)
    download_image(image_url, local_dir, name)


if __name__ == '__main__':
    app = init_firebase()
    bucket = storage.bucket()

    blob = list(bucket.list_blobs())
    files_list = []
    FOLDER_TO_SAVE = 'cyan/'
    os.makedirs(FOLDER_TO_SAVE, exist_ok=True)

    for item in blob:
        file_name = item.name.split('/')[-1]
        file_dir = item.name.replace(file_name, '')
        file_color = item.metadata['color'] if 'color' in item.metadata.keys() else ''

        if file_name == '':
            continue

        new_file_data = [file_dir,
                         file_name,
                         file_color]

        files_list.append(new_file_data)
        print(files_list[-1])

        if file_dir == FOLDER_TO_SAVE:
            save_image(item.name, FOLDER_TO_SAVE, file_name)
