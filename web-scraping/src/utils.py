import os
import zipfile


def zip(zip_filename, path):
    with zipfile.ZipFile(zip_filename, "w", zipfile.ZIP_DEFLATED) as zipf:
        for root, _, files in os.walk(path):
            for file in files:
                file_path = os.path.join(root, file)
                arcname = os.path.relpath(file_path, path)
                zipf.write(file_path, arcname=arcname)
