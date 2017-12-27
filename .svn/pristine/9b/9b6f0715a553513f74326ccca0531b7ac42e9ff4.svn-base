# Author = Sean Hendryx

# Script computes errors between a set of annotated and a set of predicted landmark locations
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
    sqrt(sum((x1 - x2) ^ 2))
}   

errorNormalization <- function(rmse, p1, p2){
    #normalizes the error by the interoccular distance (distance between p1 and p2)
    d_outer = sqrt((p1[[1]] - p2[[1]])^2 + (p1[[2]] - p2[[2]])^2 )
    #
    normalizedRMSE = rmse/d_outer
    #
    return(normalizedRMSE)
}

#--------------------------------------------------------------------------------#
#  MAIN 
#--------------------------------------------------------------------------------#

# Get command line arguments:
args<-commandArgs(TRUE)

writeControl = TRUE

#path to predictions
setwd("/data/faces/Landmarks/300w/experiments/OpenFace/300w_cropped/output/01_Indoor/detections")

#Read .pts file in:
list <- scan("indoor_001_det_0.pts", skip = 3, nmax = 68*2)
mat <- matrix(list, nrow = 68, ncol = 2, byrow = TRUE)
DT = as.data.table(mat)
DT[,name := "indoor_001_det_0.pts"]
DT[,image := "indoor_001"]
file = "indoor_001_det_0.pts"
DT[,face := file_path_sans_ext(read.table(text = file, sep = "_", as.is = TRUE)$V4)]

pointID <- rownames(DT)
DT <- cbind(pointID=pointID, DT)

#Add unique id for each point in all images
DT[,UID := paste0(substr("indoor_001", 1,10), "_", pointID)]


files <- list.files(pattern = "\\.pts$")

# Start at position 2, since first image already loaded into datatable
files <- files[2:length(files)]

#Make datatable of all points:
#files <- files[1:which(files == "indoor_055_det_0.pts")]
for(file in files){
    list <- scan(file, skip = 3, nmax = 68*2)
    mat <- matrix(list, nrow = 68, ncol = 2, byrow = TRUE)
    DT_i = as.data.table(mat)
    DT_i[,name := file]
    DT_i[,image := substr(file, 1,10)]

    #Add face indicator column:
    DT_i[,face := file_path_sans_ext(read.table(text = file, sep = "_", as.is = TRUE)$V4)]
    
    #Add point id:
    pointID <- rownames(DT_i)
    
    DT_i <- cbind(pointID=pointID, DT_i)
    
    #Add unique id for each point in all images
    DT_i[,UID := paste0(substr(file, 1,10), "_", pointID)]
    
    DT <- rbind(DT, DT_i)
}

#Now make same DT of ground truths (annotated dataset).
#path to annotations:
setwd("/data/faces/Landmarks/300w/annotations/300w_cropped/01_Indoor")
files <- list.files(pattern = "\\.pts$")

#Read .pts file in:
list <- scan("indoor_001.pts", skip = 3, nmax = 68*2)
mat <- matrix(list, nrow = 68, ncol = 2, byrow = TRUE)
annoDT = as.data.table(mat)
annoDT[,name := "indoor_001.pts"]
annoDT[,image := "indoor_001"]


pointID <- rownames(annoDT)
annoDT <- cbind(pointID=pointID, annoDT)

#Add unique id for each point in all images
annoDT[,UID := paste0(substr("indoor_001", 1,10), "_", pointID)]

# Start at position 2, since first image already loaded into datatable, annoDT
files <- files[2:length(files)]
for(file in files){
    list <- scan(file, skip = 3, nmax = 68*2)
    mat <- matrix(list, nrow = 68, ncol = 2, byrow = TRUE)
    DT_i = as.data.table(mat)
    DT_i[,name := file]
    DT_i[,image := substr(file, 1,10)]

    #Add point id:
    pointID <- rownames(DT_i)
    
    DT_i <- cbind(pointID=pointID, DT_i)
    
    #Add unique id for each point in all images
    DT_i[,UID := paste0(substr(file, 1,10), "_", pointID)]

    annoDT <- rbind(annoDT, DT_i)
}

######################################################################################################################################################################################################################################################################################################################################################################################
# Now run analyses:

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
rmse_all_points = sqrt(mean(dist^2))
print(paste0("UnnoRMSE between all points: ", rmse_all_points))

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
    
    dist <- NULL
    for(i in 1:nrow(X1)){
        dist[i] <- euc.dist(X1[i,],X2[i,])
    }
    #dist
    
    #RMSE:
    rmse = sqrt(mean(dist^2))
    
    #normalize error by interocular distance (distance between landmark 37 and landmark 46)
    p1 = X1[37,]
    p2 = X2[46,]
    rmse = errorNormalization(rmse, p1, p2)
    
    print(paste0("Normalized RMSE between points of face ",imageFace_i, ": ", rmse))
    
    errorByFaceDT[imageFace == imageFace_i,RMSE := rmse]
}

# Compute Mead Absolute Deviation (MAD) for all points, normalized by interocular distance:
normalized_MAD_all_points = median(abs(errorByFaceDT[,RMSE]))
print(paste0("Mead Absolute Deviation (MAD) for all points, normalized by interocular distance:"))
print(normalized_MAD_all_points)

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
    setwd("/data/faces/Landmarks/300w/experiments/OpenFace/300w_cropped/output/01_Indoor")
    write.csv(distDT, "Euclidean_distance_between_predictions_and_annotations.csv")
    write.csv(normalized_MAD_all_points, "normalized_MAD_between_all_predictions_and_annotations.csv")
    write.csv(errorByFaceDT, "interoccular_normalized_RMSE_between_predictions_and_annotations_by_face.csv")
}




plotter = FALSE
if(plotter){
    # Now plot by point
    p <- ggplot(data = distDT, aes(x = reorder(pointID.x, as.numeric(pointID.x)), y = distance)) + geom_boxplot(col = "darkblue") + theme_bw() +labs(title = "Euclidean Distance by Facial Landmark", y = "Distance (pixels)", x = "Facial Landmark ID")
    p

    dev.new()
    p2 <- ggplot(data = distDT, aes(x = image, y = distance)) + geom_boxplot(col = "darkblue") + theme_bw() +labs(title = "Euclidean Distance by Image", y = "Distance (pixels)", x = "Image")
    p2

    # Boxplots by image with face indicator:
    dev.new()
    p3 <- ggplot(data = distDT, aes(x = imageFace, y = distance)) + geom_boxplot(col = "darkblue") + theme_bw() +labs(title = "Euclidean Distance by Image", y = "Distance (pixels)", x = "Image")
    p3

    #Hosting graphs in online plotly account
    Sys.setenv("plotly_username"="seanmhendryx1")
    Sys.setenv("plotly_api_key"="fe6vm0q3k9")

    p3ly <- ggplotly(p3)

    plotly_POST(p3ly, filename = "Euclidean_Distance_by_Image_300W_Dataset_All_Images_from_OpenFace_Output_w_Face_Indicator")

    #p2ly <- ggplotly(p2)


#plotly_POST(p2ly, filename = "Euclidean_Distance_by_Image_300W_Dataset_All_Images_from_OpenFace_Output")
}





















