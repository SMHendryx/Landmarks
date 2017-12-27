'''
This code convert the Face++ results of Landmarks 83 points to AFLW 21 points format.
Name: Jinlong Lin
'''

import os

filepath = r"D:\Face++\Outdoor_Output" #Given the dir for result txt file
output_path = r"D:\Face++\FacePP_21Points\Outdoor_Output" #Given the dir for converted result
Index_in_Facepp_output= {1:30,2:36,3:34,4:76,5:82,6:80,7:22,8:21,9:26,10:68,11:67,
                         12:72,13:0,14:63,15:59,16:64,17:0,18:38,19:[46,48],20:47,21:1}

for filename in os.listdir(filepath):
    #Import the result from Face++
    filedir = os.path.join(filepath,filename)
    file = open(filedir,"r")
    dic = eval(file.read())
    
    #Convert the result
    keys = sorted(list(dic['faces'][0]['landmark'].keys()))
    Facepp_output_in_21points_format = ""
    for ele in range(1,22):
        if ele == 19:
            x46 = dic['faces'][0]['landmark'][keys[Index_in_Facepp_output[19][0]-1]]['x']
            y46 = dic['faces'][0]['landmark'][keys[Index_in_Facepp_output[19][0]-1]]['y']
            x48 = dic['faces'][0]['landmark'][keys[Index_in_Facepp_output[19][1]-1]]['x']
            y48 = dic['faces'][0]['landmark'][keys[Index_in_Facepp_output[19][1]-1]]['y']
            x = (x46+x48)/2
            y = (y46+y48)/2
            Facepp_output_in_21points_format += str(ele)+ " " + str(x) + " " + str(y) + '\n'
            
        elif Index_in_Facepp_output[ele] != 0:
            x = dic['faces'][0]['landmark'][keys[Index_in_Facepp_output[ele]-1]]['x']
            y = dic['faces'][0]['landmark'][keys[Index_in_Facepp_output[ele]-1]]['y']
            Facepp_output_in_21points_format += str(ele)+ " " + str(x) + " " + str(y) + '\n'
            

    #Store the retuls
    resultdir = os.path.join(output_path,filename)
    result = open(resultdir,"w+")
    result.write(Facepp_output_in_21points_format)
    result.close()
    
