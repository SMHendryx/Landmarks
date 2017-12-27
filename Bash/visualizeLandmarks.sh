# Runs visualizeLandmarks.py
# Should be run from same directory as visualizeLandmarks.py

# Make sure to activate environment:
source /Users/seanmhendryx/virtualenvs/visualizeLandmarksVenv/bin/activate

#cd to code:
cd /Users/seanmhendryx/ivilab/svn/Landmarks_repo/Landmarks/Python

baseImagePath='/Users/seanmhendryx/Data/landmarks/annotated_datasets/300w/300w_cropped/02_Outdoor'
outputPath='/Users/seanmhendryx/Data/landmarks/experiments/landmarkVisualizations'
annoPath='/Users/seanmhendryx/Data/landmarks/annotated_datasets/300w/300w_cropped/02_Outdoor'
fppPath=''
ofPath='/Users/seanmhendryx/Data/landmarks/experiments/OpenFace/errorResults/outdoor/detections'
python visualizeLandmarks.py $baseImagePath $outputPath $annoPath $ofPath
