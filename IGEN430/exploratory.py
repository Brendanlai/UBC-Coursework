import numpy as np
import cv2
import os
from matplotlib import pyplot as plt


def main():
    img = cv2.imread('/Users/brendanlai/Documents/IGEN430/images/240fps/7.jpg')
    edges = cv2.Canny(img,100,200)

    """
        Plot and show the edges in the image
    """
    plt.subplot(121),plt.imshow(img,cmap = 'gray')
    plt.title('Original Image'), plt.xticks([]), plt.yticks([])
    plt.subplot(122),plt.imshow(edges,cmap = 'gray')
    plt.title('Edge Image'), plt.xticks([]), plt.yticks([])
    plt.show()


    # img = cv2.imread('/Users/brendanlai/Documents/IGEN430/images/240fps/1.jpg')
    # img = cv2.medianBlur(img,5)
    # cimg = cv2.cvtColor(img,cv2.COLOR_GRAY2BGR)
    # circles = cv2.HoughCircles(img,cv2.HOUGH_GRADIENT,1,20,param1=50,param2=30,minRadius=0,maxRadius=0)
    # circles = np.uint16(np.around(circles))
    # for i in circles[0,:]:
    #     # draw the outer circle
    #     cv2.circle(cimg,(i[0],i[1]),i[2],(0,255,0),2)
    #     # draw the center of the circle
    #     cv2.circle(cimg,(i[0],i[1]),2,(0,0,255),3)
    # cv2.imshow('detected circles',cimg)
    # cv2.waitKey(0)


if __name__ == '__main__':
    main()