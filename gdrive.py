from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload
from google.oauth2 import service_account
import io
import json


with open("tattooai-6c2b2fb6e4ab.json") as file:
    credz = json.load(file)

# More info: https://cloud.google.com/docs/authentication

credentials = service_account.Credentials.from_service_account_info(credz)
drive_service = build('drive', 'v3', credentials=credentials)

file_id = '15Dej2FhyQL38TlkXTHvHiH93Hy-dZXGW'
request = drive_service.files().get_media(fileId=file_id)
# fh = io.BytesIO() # this can be used to keep in memory
fh = io.FileIO('image.PNG', 'wb')  # this can be used to write to disk
downloader = MediaIoBaseDownload(fh, request)
done = False
while done is False:
    status, done = downloader.next_chunk()
    print("Download %d%%." % int(status.progress() * 100))

# request = drive_service.files().get_media(fileId=file_id)
# fh = io.BytesIO()
# downloader = MediaIoBaseDownload(fh, request)
# done = False
# while done is False:
#     status, done = downloader.next_chunk()
#     print( ")Download %d%%." % int(status.progress() * 100))
