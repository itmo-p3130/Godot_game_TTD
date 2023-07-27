from concurrent.futures import ThreadPoolExecutor
from pydrive2.auth import GoogleAuth
from pydrive2.drive import GoogleDrive
from pydrive2.fs import GDriveFileSystem
import os
import shutil


CACHED_CREDENTIALS_FILE = "my-credentials.txt"
REMOTE_RESOURCES_DIRECTORY_ID = "1cSfAusfRTaaW_-SmreXLa-54SjN_2eN6"
LOCAL_RESOURCES_PATH = "models"


def download_file(args):
    remote_path, local_path = args
    print(f"Downloading {local_path} ...")

    file_id = fs._get_item_id(REMOTE_RESOURCES_DIRECTORY_ID + "/" + remote_path)
    file = drive.CreateFile({ "id": file_id })
    file.GetContentFile(local_path)


gauth = GoogleAuth()
gauth.LoadCredentialsFile(CACHED_CREDENTIALS_FILE)
try:
    if gauth.credentials is None:
        gauth.LocalWebserverAuth()
    elif gauth.access_token_expired:
        gauth.Refresh()
    else:
        gauth.Authorize()
except:
    gauth.LocalWebserverAuth()
gauth.SaveCredentialsFile(CACHED_CREDENTIALS_FILE)

drive = GoogleDrive(gauth)

fs = GDriveFileSystem(REMOTE_RESOURCES_DIRECTORY_ID, google_auth=gauth)

if (os.path.isdir(LOCAL_RESOURCES_PATH) and
    input(f"Delete local {LOCAL_RESOURCES_PATH} folder with all of it's content? (Print YES) ") == "YES" and
    input("Are you sure? (Print YES) ") == "YES"):
        shutil.rmtree(LOCAL_RESOURCES_PATH)

os.makedirs(LOCAL_RESOURCES_PATH)

downloader = ThreadPoolExecutor(4)
for root, dnames, fnames in fs.walk("."):
    path_filter = lambda x: x not in ["", "."]

    root = list(filter(path_filter, root.split("/")))
    local_root = list(filter(path_filter,
                             [LOCAL_RESOURCES_PATH, *root]))

    for dname in dnames:
        path = "/".join(local_root + [dname])
        print(f"Creating {path} ...")

        os.makedirs(path)

    for fname in fnames:
        remote_path = "/".join(root + [fname])
        local_path = "/".join(local_root + [fname])

        downloader.submit(download_file, [remote_path, local_path])
