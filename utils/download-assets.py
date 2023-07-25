from pydrive2.auth import GoogleAuth
from pydrive2.drive import GoogleDrive
from pydrive2.fs import GDriveFileSystem
import os
import copy
import shutil


CACHED_CREDENTIALS_FILE = "my-credentials.txt"
REMOTE_RESOURCES_PATH = "ttd/Sprites"
LOCAL_RESOURCES_PATH = "res"


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

fs = GDriveFileSystem("root", google_auth=gauth)

if (os.path.isdir(LOCAL_RESOURCES_PATH) and
    input(f"Delete local {LOCAL_RESOURCES_PATH} folder with all of it's content? ") == "YES" and
    input("Are you sure? ") == "YES"):
        shutil.rmtree(LOCAL_RESOURCES_PATH)

os.makedirs(LOCAL_RESOURCES_PATH)

path_length = len(REMOTE_RESOURCES_PATH.split("/"))
dirs = ["/" + REMOTE_RESOURCES_PATH]
while len(dirs) > 0:
    dirs_copy = copy.copy(dirs)
    dirs = []
    for dir in dirs_copy:
        for root, dnames, fnames in fs.walk(dir):
            # print(root)
            local_root = LOCAL_RESOURCES_PATH + "/" + "/".join(root.split("/")[path_length:])

            print(f"Creating {local_root} ...")
            os.makedirs(local_root)

            for dname in dnames:
                dirs.append(dir + "/" + dname)

            for fname in fnames:
                print(f"Downloading {fname}...")
                file = drive.ListFile({'q': f"title = '{fname}'"}).GetList()[0]
                file.GetContentFile(local_root + "/" + fname)
