from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload
from google.oauth2 import service_account
import io
import json
import enum


class MimeType(enum.Enum):
    folder = "mimeType = 'application/vnd.google-apps.folder'"
    png = "mimeType = 'image/png'"
    all = None


class DriveService:

    def __init__(self):
        self.drive_service = self.load_drive_credentials()
        self.files_list = self.get_files_list()

    @staticmethod
    def load_drive_credentials():
        with open("tattooai-6c2b2fb6e4ab.json") as file:
            creds = json.load(file)
        credentials = service_account.Credentials.from_service_account_info(creds)
        drive_serv = build('drive', 'v3', credentials=credentials)

        return drive_serv

    @staticmethod
    def __download_file(req, name):
        fh = io.FileIO(name, 'wb')  # this can be used to write to disk
        downloader = MediaIoBaseDownload(fh, req)
        done = False
        while done is False:
            status, done = downloader.next_chunk()
            print(f"Download '{name}' %d%%." % int(status.progress() * 100))

    '''Get list of dicts with all item on Drive (including folders)'''
    def get_files_list(self, mime_type=None):
        files_ref = self.drive_service.files()\
            .list(q=mime_type)\
            .execute()
        list_files = files_ref.get('files', [])

        return list_files

    def download_file_by_name(self, name):
        file_id = ""

        for item in self.files_list:
            if item["name"] == name:
                file_id = item["id"]

        if file_id != "":
            request = self.drive_service.files().get_media(fileId=file_id)
            self.__download_file(request, name)
        else:
            print(f'File named {name} not found.')

    def download_all_files(self):
        for item in self.files_list:
            if item["mimeType"] not in MimeType.folder.value:
                request = self.drive_service.files().get_media(fileId=item["id"])
                self.__download_file(request, item["name"])


if __name__ == "__main__":

    drive = DriveService()
    # print(drive.get_files_list(MimeType.png.value))

    drive.download_all_files()

    # image_file_name = "stocks_dark.PNG"
    # drive.download_file_by_name(image_file_name)
