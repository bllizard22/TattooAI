import os
import firebase_admin
from firebase_admin import credentials
from firebase_admin import storage

# cred = credentials.Certificate("firephotos-40d70-firebase-adminsdk-g8g4q-97ab5f73d2.json")
# firebase_admin.initialize_app(cred)

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
        cred = credentials.Certificate('firephotos-40d70-firebase-adminsdk-g8g4q-97ab5f73d2.json')
    else:
        cred = credentials.ApplicationDefault()

    firebase_app = firebase_admin.initialize_app(cred, {
        # 'projectId': PROJECT_ID,
        'storageBucket': f"{PROJECT_ID}.appspot.com"
    })

    return firebase_app


if __name__ == "__main__":
    init_firebase()

    try:
        # Upload
        bucket = storage.bucket()
        blob = bucket.blob(os.path.basename(r'C:\Users\n.kruchkov\Desktop\Python\TattooAI'))
        blob.upload_from_filename("test0.txt")
        # # blob.upload_from_string("hello world")
        #
        # # Upload from file
        # blob.upload_from_filename("test0.txt")
    # except:
    #     pass
    finally:
        print("End")
