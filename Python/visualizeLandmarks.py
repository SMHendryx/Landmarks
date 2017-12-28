# Visualizes landmarks specified in args on top of base image. Requires image and landmark file names to correspond
# Top-level, 'main' program
# Author: Sean Hendryx seanmhendryx@email.arizona.edu
# Nov. 2017

__author__ = 'seanmhendryx'


import os
import sys
from glob import glob
import numpy
from PIL import Image
from PIL import ImageDraw


def main():
    """
    FIRST ARGUMENT: path to base images
    SECOND ARGUMENT: path to write output (plotted landmarks)
    THIRD ARGUMENT: path to annotations
    FOURTH ARGUMENT ONWARDS: additional coordinate files to be plotted, such as from landmark-finding software
    
    psuedocode:
    Read args
    For each file in annotations
        Plot coordinate files
    """

    args = sys.argv

    # get directory of annotations:
    annoDirec = getAnnoDirec(args)

    baseImageFiles = getListOfImageFiles(annoDirec)

    #output direc:
    outputDirecPath = args[2]

    # get directories of coordinates INCLUDING ANNOTATIONS
    coordDirecs = getCoordDirecs(args)
    print("coordDirecs", coordDirecs)

    #plot coords specified in args:
    for direc in coordDirecs:
        #Loop through base image files:
        for bif in baseImageFiles:
            print("Plotting landmarks on: ")
            print(bif)
            #read in image:
            img = Image.open(bif, mode='r')

            #draw image:
            plot = ImageDraw.Draw(img)

            #to show image: (don't do this)
            #img.show()

            baseImageFileString = os.path.basename(bif)
            baseImageFileStringNoExt = os.path.splitext(baseImageFileString)[0]


            print("Plotting coordinates for ", direc, " on ", bif, ".")

            # I am here:
            # Find corresponding landmark file in direc for bif:
            landmarkFile = findCorrespondingLandmarkFile(bif, direc)
            #print(bif, " corresponding landmark file: ", landmarkFile)

            if landmarkFile != None:
                landmarkFormat = guessLandmarkFormatOfFile(landmarkFile)
                print("Landmark format: ", landmarkFormat)

                #now plot landmarks:
                # plotLandmarksOnBaseImage() assumes image is already open
                # I AM HERE:
                plotLandmarksOnBaseImage(baseImageFileStringNoExt,img, plot, landmarkFile, landmarkFormat, outputDirecPath)

            savePlotOfLandmarksOnBaseImage(baseImageFileStringNoExt, img, landmarkFormat, outputDirecPath)
            # end bif for loop
        #end direc for loop

#end main()


def savePlotOfLandmarksOnBaseImage(baseImageFileStringNoExt, img, landmarkFormat, outputDirecPath):
    # Save the plotted landmarks on a PIL Image object in a new directory of name landmarkFormat inside outputDirecPath. Assumes Image is already open.
    # :param baseImageFileStringNoExt: base image file (string of base image name (not complete path))
    # :param img: PIL Image object
    # :param landmarkFormat: String specifying inferred landmark format
    # :param outputDirecPath: path to save images with plotted landmarks (in which a new directory will be created if it does not exist)

    landmarkFormatDirec = landmarkFormat
    outputDirecPath = os.path.join(outputDirecPath, landmarkFormatDirec)

    if not os.path.exists(outputDirecPath):
        os.makedirs(outputDirecPath)

    img.save(os.path.join(outputDirecPath, baseImageFileStringNoExt + "_visualized.png"))
    
    #except:
    #    img.save(os.path.join(outputDirecPath,baseImageFileStringNoExt+"_unable_to_visualize.png"))
    print("Saved file with 300w landmarks: ", baseImageFileStringNoExt)

def plotLandmarksOnBaseImage(baseImageFileStringNoExt, img, plot, landmarkFile, landmarkFormat, outputDirecPath):
    # Plot the landmarks on a PIL Image object. Assumes Image is already open.
    # :param baseImageFileStringNoExt: base image file (string of base image name (not complete path))
    # :param img: PIL Image object
    # :param plot: PIL ImageDraw.Draw object
    # :param landmarkfile: txt document of landmark coordinates
    # :param landmarkFormat: format of landmark coordinates file

    # Make a series of ifelses to control calling 
    # correct function for plotting landmarks files of type landmarkFormat
    # I AM HERE
    #   TODO:
    if landmarkFormat == "300wAnnotations":
        plot300wLandmarksOnBaseImage(baseImageFileStringNoExt, img, plot, landmarkFile, outputDirecPath)
    elif landmarkFormat == "OpenFaceNativeOutput":
        plotOpenFaceLandmarksOnBaseImage(baseImageFileStringNoExt, img, plot, landmarkFile, outputDirecPath)
    elif landmarkFormat == "Face++NativeOutput":
        plotFacePPLandmarksOnBaseImage(baseImageFileStringNoExt, img, plot, landmarkFile, outputDirecPath)

def plotFacePPLandmarksOnBaseImage(baseImageFileStringNoExt, img, plot, landmarkFile, outputDirecPath):
    # :param baseImageFileStringNoExt: base image file (string of base image name (not complete path))
    # :param img: PIL Image object
    print("Code to complete")

def plotOpenFaceLandmarksOnBaseImage(baseImageFileStringNoExt, img, plot, landmarkFile, outputDirecPath):
    # :param baseImageFileStringNoExt: base image file (string of base image name (not complete path))
    # :param img: PIL Image object
    landmarks = numpy.genfromtxt(landmarkFile, delimiter=' ', skip_header =3, skip_footer = 50)
    #Visualization
    #print("plot object: ", plot)
    #print("img object: ", img)
    #numLandmarkLines = 68
    #landmarks = landmarks[0:numLandmarkLines - 1]
    for i in numpy.arange(landmarks.shape[0]):
        x = landmarks[i,0]
        y = landmarks[i,1]
        plot.text(xy = (x,y), text = "*"+str(i+1))#, fill = (255,0,0, 255))

def plot300wLandmarksOnBaseImage(baseImageFileStringNoExt, img, plot, landmarkFile, outputDirecPath):
    # :param baseImageFileStringNoExt: base image file (string of base image name (not complete path))
    # :param img: PIL Image object
    landmarks = numpy.genfromtxt(landmarkFile, delimiter=' ', skip_header =3, skip_footer = 1)
    #Visualization
    #print("plot object: ", plot)
    #print("img object: ", img)
    for i in numpy.arange(landmarks.shape[0]):
        x = landmarks[i,0]
        y = landmarks[i,1]
        plot.text(xy = (x,y), text = "*"+str(i+1))#, fill = (255,0,0, 255))


def guessLandmarkFormatOfFile(fileName):
    # Guesses the landmark format from the files in direc
    # For now just read lines
    minOpenFaceNativeNumLines = 121
    maxFacePPNativeNumLines = 1
    # Face++ will output 7 or 8 line error message, may need some way to deal with that
    multipieNumLines = 68
    # I am here
    AFLWNumLines = 21

    annotationsNumLines_300w = 72

    linesInFile = getNumLines(fileName)

    #print("linesInFile", linesInFile)

    if linesInFile >= 121:
        landmarkFormat = "OpenFaceNativeOutput"
    elif linesInFile == 1:
        landmarkFormat = "Face++NativeOutput"
    elif linesInFile == 68:
        landmarkFormat = "multiePIE68Points"
    elif  linesInFile == 72:
        landmarkFormat = "300wAnnotations"

    print("landmarkFormat of file, ", fileName, " : ", landmarkFormat,)
    return(landmarkFormat)



def findCorrespondingLandmarkFile(imageName, landmarkDirec):
    # ASSUMES FILE NAMES ARE 300W STRING FORMAT

    landFiles = getListOfLandmarkFiles(landmarkDirec)

    landmarkExtension = os.path.splitext(landFiles[0])[1]
    landmarkParentFolder = os.path.dirname(landFiles[0])

    baseImageFile=os.path.basename(imageName)

    if baseImageFile[0:7] == 'outdoor':
        keyNumChars = 11
        key = baseImageFile[0:keyNumChars]

    elif baseImageFile[0:6] == 'indoor':
        keyNumChars = 10
        key = baseImageFile[0:keyNumChars]

    
    else:
        raise ValueError("Image file name not correct number of characters. Should be following 300w dataset naming conventions.")


    #print("keyNumChars ", keyNumChars)

    # FIND THE LANDMARK FILE THAT CORRESPONDS TO THE IMAGE NAME BY MATCHING THE FIRST FEW CHARACTERS
    landmarkFile = None
    for file in landFiles:
        baseLandFile = os.path.basename(file)
        #print("baseLandFile", baseLandFile)
        matcher = baseLandFile[0:keyNumChars]
        #print("matcher: ", matcher)
        #print("key: ", key)
        if matcher == key:
            print("Match found!")
            print(imageName, " corresponds to: ", file)
            print(file)
            #baseLandmarkFile = baseLandFile[0:keyNumChars]
            landmarkFile = file

    #landmarkFile = os.path.join(landmarkParentFolder, baseLandmarkFile + landmarkExtension)

    if landmarkFile == None:
        print("No corresponding landmark file for ", imageName)
        return None

    print("landmarkFile for ", imageName, ":", landmarkFile)

    return(landmarkFile)



def guessLandmarkFormat(direc):
    # Guesses the landmark format from the files in direc
    # For now just read lines
    minOpenFaceNativeNumLines = 121
    maxFacePPNativeNumLines = 1
    # Face++ will output 7 or 8 line error message, may need some way to deal with that
    multipieNumLines = 68
    # I am here
    AFLWNumLines = 21

    files = getListOfLandmarkFiles(direc)

    linesInFirstFile = getNumLines(files[0])

    print("linesInFirstFile", linesInFirstFile)

    #if linesInFirstFile


def getNumLines(filePath):
    count = len(open(filePath).readlines(  ))
    return(count)

def getNumLines2(file):
    with open(file) as f:
        numLines = sum(1 for _ in f)
    return(numLines)

def getListOfLandmarkFiles(direc,types = ('*.pts','*.txt')):
    # Returns list of absolute paths of Landmark text files
    grabbedFiles = []
    for ext in types:
        grabbedFiles.extend(glob(os.path.join(direc, ext)))
    
    #print("Grabbed landmark files: ")
    #print(grabbedFiles)
    print("Number of grabbedFiles in ", direc, ":")
    print(len(grabbedFiles))

    return grabbedFiles



def getListOfImageFiles(direc,types = ('*.png','*.jpg', '*.jpeg', '*.bmp')):
    # Returns list of absolute paths of images
    grabbedFiles = []
    for ext in types:
        grabbedFiles.extend(glob(os.path.join(direc, ext)))

    print("Grabbed image files: ")
    print(grabbedFiles)

    return grabbedFiles

def getCoordDirecs(args):
    # Returns the coordinate directories (starting from third argument)
    argsLength = len(sys.argv)
    #numCoordDirecs = argsLength - 3 # subtracting 2 instead of 3 bc zero-indexed
    indexOfFirstCoordDirec = 3
    coordDirecs = args[indexOfFirstCoordDirec:argsLength + 1]

    print("Directories of coordinates including annotations: ", coordDirecs)

    return coordDirecs

def getAnnoDirec(args):
    # Returns annotations directory given the arguments
    # assume anno. direc. is THIRD argument
    annoDirec = args[3]
    print("Directory of annotations: ", annoDirec)
    return annoDirec





# Main Function
if __name__ == '__main__':
    main()

