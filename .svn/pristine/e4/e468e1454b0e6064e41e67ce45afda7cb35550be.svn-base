__author__ = 'seanhendryx'

# Sean Hendryx
# Graduate Student
# INFO 521: Introduction to Machine Learning
# Script built to run on Python version 2.7
# References:


#NOTES:

#Dependencies:
import numpy
import matplotlib.pyplot as plt
import os


imagePath = "/Users/seanhendryx/IVILab/Sean_Test_Data/300W/01_Indoor/indoor_118.png"

#Load in predicted points:
path = "/Users/seanhendryx/IVILab/Sean_Test_Data/300W/OpenFace_Output/indoor_118_det_1.pts"
points = numpy.genfromtxt(path, delimiter=' ', skip_header =3, skip_footer = 50)

# Read in annotations:
path = "/Users/seanhendryx/IVILab/Sean_Test_Data/300W/01_Indoor/indoor_118.pts"
annotations = numpy.genfromtxt(path, delimiter=' ', skip_header =3, skip_footer = 1)

# example use of plt.scatter:
# put a red dot, size 40, at 2 locations:
#plt.scatter(x=[30, 40], y=[50, 60], c='r', s=40)

# Read in base image:
im = plt.imread(imagePath)
implot = plt.imshow(im)

# Plot predicted landmarks from OpenFace
plt.scatter(points[:,0], points[:,1])
plt.scatter(annotations[:,0], annotations[:,1], c = "r")

plt.show()




def main():
    """

    """
    #Do something
    #Call myFunc(withSomething)
    

def myFunc(param):
    """
    Description.
    :param param:
    """
    something = doSomethingTo(param)
    return something



# Main Function
if __name__ == '__main__':
    main()