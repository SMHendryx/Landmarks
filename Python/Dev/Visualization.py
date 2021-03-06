#This code visualizes the Face++ output (native Face++ output format)
# By Pengcheng (Patrick) Cai

import os
from PIL import Image
from PIL import ImageDraw

filepath = r"D:\Machine Learning\Kobus\300w\annotations\Face++\Outdoor_Output" #Given the dir for landmarks dictionary txt file
imgpath = r"D:\Machine Learning\Kobus\300w\annotations\300w_cropped\02_Outdoor" #dir for image
output_path = r"D:\Machine Learning\Kobus\300w\annotations\Face++\Visualized_Face++_Result\Outdoor" #Given the dir for visualized images

for filename in os.listdir(filepath):
    #Import the result dictionary
    filedir = os.path.join(filepath,filename)
    file = open(filedir,"r")
    dic = eval(file.read())
    keys = sorted(list(dic['faces'][0]['landmark'].keys()))
        
    #Import the image
    imgdir = os.path.join(imgpath,filename[0:11]+".png")
    img = Image.open(imgdir)
    draw = ImageDraw.Draw(img)

    #Visualization
    try:
        i = 1
        for ele in keys:
            x = dic['faces'][0]['landmark'][ele]['x']
            y = dic['faces'][0]['landmark'][ele]['y']
            draw.text((x,y),"*"+str(i),(255,255,255))
            img.save(os.path.join(output_path,filename[0:11]+"_visualized.png"))
            i += 1
    except:
        img.save(os.path.join(output_path,filename[0:11]+"_unable_to_visualized.png"))
    print(filename)
