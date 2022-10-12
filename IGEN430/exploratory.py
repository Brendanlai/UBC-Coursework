import numpy as np
import cv2
import os

def main():
    print(os.listdir)
    
    def load_images_from_folder(folder):
        images = []
        for filename in os.listdir(folder):
            img = cv2.imread(os.path.join(folder,filename))
            if img is not None:
                images.append(img)
        return images

    imgs = load_images_from_folder("images/240fps")
    print(imgs)
    cv2.imshow('image',imgs[0])



if __name__ == '__main__':
    main()