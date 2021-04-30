"""
This a file for batch uploading files
to Firebase Storage with certain metadata
"""

import os
from uuid import uuid4
from firebase_admin import storage
from firebase_admin import credentials

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


if __name__ == "__main__":
    app = init_firebase()

    folder_list = os.listdir('files')

    try:
        # Upload
        bucket = storage.bucket()

        for image in folder_list:
            blob = bucket.blob(image)
            blob.metadata = {'firebaseStorageDownloadTokens': uuid4(), 'color': 'colorful'}
            blob.upload_from_filename(f'resources/{image}', content_type='image/png')

        # blob_2 = bucket.blob('new.jpg')
        # blob_2.download_to_filename('new.jpg')
        # blob_2.download_to_file('new.jpg')

        # blob = bucket.blob('icon_1.png')
        # blob.upload_from_filename('resources/icon_1.png')

    except FileNotFoundError as e:
        print(e)

    finally:
        print("End")
