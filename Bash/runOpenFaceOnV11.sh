# Code used to run OpenFace on v11.
# Written by Sean Hendryx, seanmhendryx@email.arizona.edu

#Structuring directories:
#cd /data/faces/Landmarks/300w
#cp -r annotations/300w experiments/OpenFace/input
#remove annotations:
#cd experiments/OpenFace/input/300w/02_Outdoor/
#rm *.pts
#cd /data/faces/Landmarks/300w/experiments/OpenFace/input/300w/01_Indoor/
#rm *.pts

#Run OpenFace:
/misc/bin/linux_x86_64_opteron/FaceLandmarkImg -fdir /data/faces/Landmarks/300w/experiments/OpenFace/input/300w/01_Indoor -ofdir /data/faces/Landmarks/300w/experiments/OpenFace/output/detections -oidir /data/faces/Landmarks/300w/experiments/OpenFace/output/images_with_detections -q

/misc/bin/linux_x86_64_opteron/FaceLandmarkImg -fdir /data/faces/Landmarks/300w/experiments/OpenFace/input/300w/02_Outdoor -ofdir /data/faces/Landmarks/300w/experiments/OpenFace/output/02_Outdoor/detections -oidir /data/faces/Landmarks/300w/experiments/OpenFace/output/02_Outdoor/images_with_detections -q

#Run OpenFace on cropped:
#Structuring directories:
#cd /data/faces/Landmarks/300w
#cp -r annotations/300w_cropped /data/faces/Landmarks/300w/experiments/OpenFace
#remove annotations:
#cd /data/faces/Landmarks/300w/experiments/OpenFace/300w_cropped
#mv * input
#cd /data/faces/Landmarks/300w/experiments/OpenFace/300w_cropped/input/01_Indoor
#rm *.pts
#cd /data/faces/Landmarks/300w/experiments/OpenFace/300w_cropped/input/02_Outdoor
#rm *.pts

#Run OpenFace on cropped dataset:
/misc/bin/linux_x86_64_opteron/FaceLandmarkImg -fdir /data/faces/Landmarks/300w/experiments/OpenFace/300w_cropped/input/01_Indoor -ofdir /data/faces/Landmarks/300w/experiments/OpenFace/300w_cropped/output/01_Indoor/detections -oidir /data/faces/Landmarks/300w/experiments/OpenFace/300w_cropped/output/01_Indoor/images_with_detections -q 

/misc/bin/linux_x86_64_opteron/FaceLandmarkImg -fdir /data/faces/Landmarks/300w/experiments/OpenFace/300w_cropped/input/02_Outdoor -ofdir /data/faces/Landmarks/300w/experiments/OpenFace/300w_cropped/output/02_Outdoor/detections -oidir /data/faces/Landmarks/300w/experiments/OpenFace/300w_cropped/output/02_Outdoor/images_with_detections -q 

