# Author = Sean Hendryx

# Script computes errors between a set of annotated and a set of predicted landmark locations
# assumes predictions are in Face++ format converted to OpenFace
# First argument is path to directory of predictions, second is path to directory of annotations, third is directory in which to write results
# Prediction and annotion files should be in same format
# example usage: Rscript compute_RMSE_between_predictions_and_annotations.R path/to/predictions/ path/to/annotations/ path/in/which/to/write/results

##Load packages:
packages = c('ggplot2', 'data.table', 'dplyr', 'tools', 'metrics')#, 'plotly', 'phia', 'xtable', 'Morpho')
lapply(packages, library, character.only = TRUE)


# Function Declarations:
#improved print function:
printer <- function(string, var){
    print(paste0(string, " ", var))
}


euc.dist <- function(x1, x2){
    #Computes euclidean distance on vectors
    sqrt(sum(na.omit((x1 - x2) ^ 2)))
}   

normalizeErrorBYIODist <- function(rmse, p1, p2){
    #normalizes the error by the interoccular distance (distance between p1 and p2)
    # as defined in Sagonas et al 2016: 300 Faces In-The-Wild Challenge: database and results
    d_outer = sqrt((p1[[1]] - p2[[1]])^2 + (p1[[2]] - p2[[2]])^2 )
    #
    normalizedRMSE = rmse/d_outer
    #
    return(normalizedRMSE)
}

computeNormalizedRMSE <- function(distVec, p1, p2){
    # @param distVec: a vector of distances between annotations and ground truth points
    # @param p1, p2: vector of ground truth coordinates. The distance between p1 and p2 is the normalization constant
    # Return scalar normalized RMSE following Sagonas et al. 2016 eq. 8
    n = sum(!is.na(distVec))
    rmse = mean(na.omit(distVec))
    TEST = FALSE
    if(TEST){
        if(sum(na.omit(distVec))/n != rmse){
            warning("Difference in RMSE, check NA handling of function computeNormalizedRMSE.")
        }
    }
    #normalize error by interoccular distance
    return(normalizeErrorBYIODist(rmse, p1, p2))
}

#not in:
'%!in%' <- function(x,y){
    !('%in%'(x,y))
}

#--------------------------------------------------------------------------------------------------------------------------------------------------------------#
#           MAIN                                                                                                                                               #
#--------------------------------------------------------------------------------------------------------------------------------------------------------------#

#---------------------------------------------------------------------------------#
#   GET PREDICTIONS
#---------------------------------------------------------------------------------#

# Get command line arguments:
args<-commandArgs(TRUE)

writeControl <- TRUE

software = "Face++"

#path to predictions
predictionsPath <- args[1]
predictionsPath='/data/faces/Landmarks/300w/experiments/Face++/Output_in_OpenFace_format/Outdoor_Output'
setwd(predictionsPath)

#Read .pts file in:
files = list.files(pattern = ".*.txt") 

#Find empty files:
info = file.info(files)
empty = rownames(info[info$size == 0, ])

# remove empty files:
notEmpty = files %!in% empty
files = files[notEmpty]

firstFile = files[1]

#add control for files that only contain 68 points vs the files from OpenFace that contain more data:
numLines <- length(readLines(firstFile))
numLines

table = read.table(firstFile)

list <- scan(firstFile, nmax = 68*2)

mat <- matrix(list, nrow = 68, ncol = 2, byrow = TRUE)
DT = as.data.table(mat)
DT[,name := firstFile]
DT[,image := file_path_sans_ext(firstFile)]
file = firstFile
DT[,face := file_path_sans_ext(read.table(text = file, sep = "_", as.is = TRUE)$V4)]

pointID <- rownames(DT)
DT <- cbind(pointID=pointID, DT)

#Add unique id for each point in all images
numChars = 11
DT[,UID := paste0(substr(file_path_sans_ext(firstFile), 1,numChars), "_", pointID)]

# Start at position 2, since first image already loaded into datatable
files <- files[2:length(files)]

#Make datatable of all points:
#files <- files[1:which(files == "indoor_055_det_0.pts")]
for(file in files){
    list <- scan(file, nmax = 68*2)
    mat <- matrix(list, nrow = 68, ncol = 2, byrow = TRUE)
    DT_i = as.data.table(mat)
    DT_i[,name := file]
    DT_i[,image := substr(file, 1,numChars)]

    #Add face indicator column:
    DT_i[,face := file_path_sans_ext(read.table(text = file, sep = "_", as.is = TRUE)$V4)]
    
    #Add point id:
    pointID <- rownames(DT_i)
    
    DT_i <- cbind(pointID=pointID, DT_i)
    
    #Add unique id for each point in all images
    DT_i[,UID := paste0(substr(file, 1,numChars), "_", pointID)]
    
    DT <- rbind(DT, DT_i)
}

#---------------------------------------------------------------------------------#
#   GET GROUND TRUTHS
#---------------------------------------------------------------------------------#
#Now make same DT of ground truths (annotated dataset).
#path to annotations:
#"/data/faces/Landmarks/300w/annotations/300w_cropped/01_Indoor"
annotationsPath = args[2]
annotationsPath = "/data/faces/Landmarks/300w/annotations/300w_cropped/02_Outdoor"
setwd(annotationsPath)
files <- list.files(pattern = "\\.pts$")
files = files[notEmpty]

firstFile = files[1]

#Read .pts file in:
list <- scan(firstFile, skip = 3, nmax = 68*2)
mat <- matrix(list, nrow = 68, ncol = 2, byrow = TRUE)
annoDT = as.data.table(mat)
annoDT[,name := firstFile]
annoDT[,image := file_path_sans_ext(firstFile)]


pointID <- rownames(annoDT)
annoDT <- cbind(pointID=pointID, annoDT)

#Add unique id for each point in all images
numChars = 11
annoDT[,UID := paste0(substr(file_path_sans_ext(firstFile), 1,numChars), "_", pointID)]

# Start at position 2, since first image already loaded into datatable, annoDT
files <- files[2:length(files)]
for(file in files){
    list <- scan(file, skip = 3, nmax = 68*2)
    mat <- matrix(list, nrow = 68, ncol = 2, byrow = TRUE)
    DT_i = as.data.table(mat)
    DT_i[,name := file]
    DT_i[,image := substr(file, 1,numChars)]

    #Add point id:
    pointID <- rownames(DT_i)
    
    DT_i <- cbind(pointID=pointID, DT_i)
    
    #Add unique id for each point in all images
    DT_i[,UID := paste0(substr(file, 1,numChars), "_", pointID)]

    annoDT <- rbind(annoDT, DT_i)
}


#---------------------------------------------------------------------------------#
#   COMPUTE ERRORS
#---------------------------------------------------------------------------------#

keycols <- c("image", "UID")

distDT <- merge(DT,annoDT,by=keycols)

#plot(annoDT[image == "indoor_001",V1], matchedDT[image == "indoor_001",V1])

#Annotated (ground truth) point columns are *.y (because annoDT was second object given to merge() above)
#Change column names to _annotated and _predicted
X1 <- distDT[,.(V1.x, V2.x)]
X2 <- distDT[,.(V1.y, V2.y)]

dist <- NULL
for(i in 1:nrow(X1)){
    dist[i] <- euc.dist(X1[i,],X2[i,])
}
#dist

#RMSE:
rmse_all_points = sqrt(mean(na.omit(dist)^2))
print(paste0("RMSE between all points: ", rmse_all_points))

distDT[,distance := dist]

#compute error by face number:
#Add new column with image and face
distDT[,imageFace := paste0(image, "_", face)]

imageFaces = unique(distDT[,imageFace])

errorByFaceDT = data.table(imageFace = imageFaces)

for(imageFace_i in imageFaces){
    #Get predicted coordinates for face:
    X1 <- distDT[imageFace == imageFace_i,.(V1.x, V2.x)]
    #Get ground truth coordinates for face:
    X2 <- distDT[imageFace == imageFace_i,.(V1.y, V2.y)]
    
    # THIS INNER LOOP SHOULD BE VECTORIZED
    # Make distance(/error) vector for the ith face, where each element in the vector is the distance between the annotated and ground truth point:
    dist_i <- NULL
    for(i in 1:nrow(X1)){
        dist_i[i] <- euc.dist(X1[i,],X2[i,])
    }
    
    #compute normalized RMSE following Sagonas et al. 2016:
    #normalize error by interocular distance (distance between landmark 37 and landmark 46)
    p1 = X2[37,]
    p2 = X2[46,]
    rmse = computeNormalizedRMSE(dist_i, p1, p2)
    
    print(paste0("Normalized RMSE between points of face ",imageFace_i, ": ", rmse))
    
    errorByFaceDT[imageFace == imageFace_i,RMSE := rmse]
}

print(software)
# Compute Mead Absolute Deviation (MAD) for all points, normalized by interocular distance:
normalized_MAD_all_points = median(abs(errorByFaceDT[,RMSE]))
print(paste0("Mead Absolute Deviation (MAD) for all points, normalized by interocular distance:"))
print(normalized_MAD_all_points)

normalized_RMSE_all_points = sqrt(mean(na.omit(errorByFaceDT[,RMSE])))
print(paste0("RMSE for all points, normalized by interocular distance:"))
print(normalized_RMSE_all_points)


#Annotated (ground truth) point columns are *.y (because annoDT was second object given to merge() above)
#Change column names to _annotated and _predicted
distDT[,x_annotations := V1.y]
distDT[,y_annotations := V2.y]
distDT[,x_predictions := V1.x]
distDT[,y_predictions := V2.x]

distDT[,V1.y := NULL]
distDT[,V1.x := NULL]
distDT[,V2.y := NULL]
distDT[,V2.x := NULL]

if(writeControl){
    #resultsPath = args[3]
    resultsPath = "/data/faces/Landmarks/300w/experiments/Face++/Results_300w_Face++/outdoor"
    setwd(resultsPath)
    write.csv(distDT, "Euclidean_distance_between_predictions_and_annotations.csv")
    write.csv(normalized_MAD_all_points, "interoccular_normalized_MAD_between_all_predictions_and_annotations.csv")
    write.csv(normalized_RMSE_all_points, "interoccular_normalized_RMSE_between_all_predictions_and_annotations.csv")
    write.csv(errorByFaceDT, "interoccular_normalized_RMSE_between_predictions_and_annotations_by_face.csv")
}


