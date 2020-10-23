# Core
import os
import re
# External
import pydub
import requests


def download_all_aac(directory='wazobia'):
    download_path = os.path.join(os.getcwd(), directory)
    if not os.path.exists(download_path):
        os.mkdir(download_path)
    with open("urls.txt", "r") as urls_file:
        pattern = re.compile(r'T-\d{3}__\w+__\d+')
        for line in urls_file:
            url = line
            print(url)
            response = requests.get(url)
            file_name = pattern.search(url).group(0) + '.aac'
            dir_to_write = os.path.join(
                download_path, file_name.split('__')[0])
            if not os.path.exists(dir_to_write):
                os.mkdir(dir_to_write)
            with open(os.path.join(dir_to_write, file_name), 'wb') as aac_file:
                aac_file.write(response.content)


def convert_aac_to_flac(directory='wazobia'):
    for subdir, dirs, files in os.walk(directory):
        for f in files:
            if f.endswith('.aac'):
                aac_file_path = os.path.join(subdir, f)
                flac_name = f.split('.')[0] + '.flac'
                print(flac_name)
                sound = pydub.AudioSegment.from_file(file=aac_file_path, format='aac')
                sound.export(out_f=os.path.join(subdir, flac_name), format='flac')


def delete_all_codec(codec, directory='wazobia'):
    if codec not in ['aac', 'flac']:
        raise Exception('only \'aac\' and \'flac\' codecs supported')

    for subdir, dirs, files in os.walk(directory):
        for f in files:
            if f.endswith(codec):
                file_path = os.path.join(subdir, f)
                os.remove(file_path)


# download_all_aac(directory='test')               
# convert_aac_to_flac(directory='test')
# delete_all_codec(codec='flac', directory='test')
