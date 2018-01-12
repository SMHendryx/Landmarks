# Example script to run visualizeLandmarks.py

# Activate virtual environment:
source /Users/seanmhendryx/virtualenvs/visualizeLandmarksVenv/bin/activate

# go to script:
cd /Users/seanmhendryx/ivilab/svn/Landmarks_repo/Landmarks/Python

baseImagePath='/Users/seanmhendryx/Data/landmarks/annotated_datasets/300w/300w_cropped/02_Outdoor'
outputPath='/Users/seanmhendryx/Data/landmarks/experiments/landmarkVisualizations'
annoPath='/Users/seanmhendryx/Data/landmarks/annotated_datasets/300w/300w_cropped/02_Outdoor'
fppPath=''
ofPath='/Users/seanmhendryx/Data/landmarks/experiments/OpenFace/errorResults/outdoor/detections'
python visualizeLandmarks.py $baseImagePath $outputPath $annoPath $ofPath
