# Runs RMSE script

predictionsPath='/data/faces/Landmarks/300w/experiments/Face++/Output_in_OpenFace_format/Indoor_Output'
annotaions='/data/faces/Landmarks/300w/annotations/300w_cropped/01_Indoor'
writeDirec='/data/faces/Landmarks/300w/experiments/Face++/results'

Rscript compute_RMSE_between_precdictions_and_annotations_Face++.R $predictionsPath $annotations $writeDirec
