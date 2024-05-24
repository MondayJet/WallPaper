import requests
import os
import ctypes
import re

def download_bing_wallpaper(save_dir):
    # Bing Wallpaper API URL
    url = "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US"

    # Make a GET request to the API
    response = requests.get(url)
    data = response.json()

    # Extract the image URL
    image_url = "https://www.bing.com" + data['images'][0]['url']

    # Extract the image filename from the URL
    image_filename = os.path.basename(image_url.split('?')[0])

    # Download the image
    image_response = requests.get(image_url)
    image_file_path = os.path.join(save_dir, image_filename)
    with open(image_file_path, 'wb') as f:
        f.write(image_response.content)

    return image_file_path


def set_wallpaper(image_path):
    # Set wallpaper using ctypes on Windows
    ctypes.windll.user32.SystemParametersInfoW(20, 0, image_path, 0)

def main():
    # Directory to save downloaded wallpapers
    save_dir = r"C:\Users\Public\Desktop"

    # Download Bing Wallpaper
    image_path = download_bing_wallpaper(save_dir)

    # Set wallpaper
    set_wallpaper(image_path)

if __name__ == "__main__":
    main()
