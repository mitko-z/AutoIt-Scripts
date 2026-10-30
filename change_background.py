import ctypes
import os
import random
import time

SPI_SETDESKWALLPAPER = 20
WALLPAPER_PATH = r'C:\work\docs\backgrounds'

def change_wallpaper(image_path):
    ctypes.windll.user32.SystemParametersInfoW(SPI_SETDESKWALLPAPER, 0, image_path, 3)

def get_random_image():
    image_files = [f for f in os.listdir(WALLPAPER_PATH) if f.endswith('.jpg') or f.endswith('.png')]
    if image_files:
        return os.path.join(WALLPAPER_PATH, random.choice(image_files))
    return None

def main():
    while True:
        image_path = get_random_image()
        if image_path:
            change_wallpaper(image_path)
            time.sleep(600)  # Sleep for 10 minutes

if __name__ == '__main__':
    main()
