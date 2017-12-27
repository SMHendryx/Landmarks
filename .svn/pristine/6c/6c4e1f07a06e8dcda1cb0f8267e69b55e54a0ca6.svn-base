# Code computes percentage of files run from total. Number of files in output is divided by number of files in input
# Currenlty meant to be run interactively. Though could be turned into a proper bash script where the first argument is input directory, second argument is output directory
# Written by Sean Hendryx, seanmhendryx@email.arizona.edu

input=/data/faces/Landmarks/300w/experiments/OpenFace/300w_cropped/input/02_Outdoor/
output=/data/faces/Landmarks/300w/experiments/OpenFace/300w_cropped/output/02_Outdoor/detections
inputNumber=$(ls $input | wc -l)
outputNumber=$(ls $output | wc -l)
percentage=$(echo "scale=4; $outputNumber/$inputNumber" | bc)
echo "Percentage of files run."
echo $percentage
