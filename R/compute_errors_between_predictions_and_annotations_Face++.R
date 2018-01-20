# Author = Sean Hendryx for the IVI-Lab at the University of Arizona

# Script computes errors between a set of annotated and a set of predicted landmark locations
# Prediction and annotion files should be in same format
# Currently scripted with hard coded paths

# TODO: Extend to run with args ala:
# First argument is path to directory of predictions, second is path to directory of annotations, third is directory in which to write results
# example usage: Rscript compute_RMSE_between_predictions_and_annotations.R path/to/predictions/ path/to/annotations/ path/in/which/to/write/results


#--------------------------------------------------------------------------------#
#  LOAD PACKAGES
#--------------------------------------------------------------------------------#
# Must source helper functions (currently coded assuming that the helper function file is in the same directory from which the script is run):
source("landmark_error_functions.R")

packages = c('ggplot2', 'data.table', 'dplyr', 'tools')#, 'metrics', 'plotly', 'phia', 'xtable', 'Morpho')

installAndLoadPackages(packages)

# getArgs() CURRENTLY NOT USED:
getArgs = function(arg){
  args<-commandArgs(TRUE)
}

setArgs = function(setting){
  #--------------------------------------------------------------------------------#
  #  SET ARGS
  #--------------------------------------------------------------------------------#
  software = "Face++"
  writeControl = TRUE
  if(setting == "Indoor"){
    pathToPredictions = "/data/faces/Landmarks/300w/experiments/Face++/Output_in_OpenFace_format/Indoor_Output"
    stopIfDoesNotExist(pathToPredictions)
    pathToAnnotations = "/data/faces/Landmarks/300w/annotations/300w_cropped/01_Indoor"
    stopIfDoesNotExist(pathToAnnotations)
    pathInWhichToWrite = "/data/faces/Landmarks/300w/experiments/Face++/Error_Results_300w_Face++/normalized_error_for_each_landmark/01_Indoor"
    stopIfDoesNotExist(pathInWhichToWrite)
  } else if(setting == "Outdoor"){
    pathToPredictions = "/data/faces/Landmarks/300w/experiments/Face++/Output_in_OpenFace_format/Outdoor_Output"
    stopIfDoesNotExist(pathToPredictions)
    pathToAnnotations = "/data/faces/Landmarks/300w/annotations/300w_cropped/02_Outdoor"
    stopIfDoesNotExist(pathToAnnotations)
    pathInWhichToWrite = "/data/faces/Landmarks/300w/experiments/Face++/Error_Results_300w_Face++/normalized_error_for_each_landmark/02_Outdoor"
    stopIfDoesNotExist(pathInWhichToWrite)
  } 

  args = c(software, writeControl, pathToPredictions, pathToAnnotations, pathInWhichToWrite)

  return(args)
}

getPredictions = function(pathToPredictions){
  #--------------------------------------------------------------------------------#
  #  GET COORDINATES OF PREDICTIONS 
  #--------------------------------------------------------------------------------#
  print("Getting coordinates of predictions.")
  setwd(pathToPredictions)

  #Read .txt files in:
  files = list.files(pattern = ".*.txt") 

  #Find empty files:
  info = file.info(files)
  empty = rownames(info[info$size == 0, ])

  # remove empty files:
  notEmpty = files %!in% empty
  files = files[notEmpty]

  printer("Getting coordinates from files: ", files)

  firstFile = files[1]

  #add control for files that only contain 68 points vs the files from OpenFace that contain more data:
  #numLines <- length(readLines(firstFile))
  numLines = 68

  df = read.table(firstFile, fill = TRUE, na.strings = c("NA", "NaN"), nrows = numLines)

  #list <- scan(firstFile, nmax = 68*2, fill = TRUE)

  #list <- scan(firstFile, nmax = 68*2, fill = TRUE)

  #mat <- matrix(list, nrow = 68, ncol = 2, byrow = TRUE)
  DT = as.data.table(df)
  DT[,name := firstFile]
  DT[,image := file_path_sans_ext(firstFile)]
  file = firstFile
  DT[,face := file_path_sans_ext(read.table(text = file, sep = "_", as.is = TRUE)$V4)]

  pointID <- rownames(DT)
  DT <- cbind(pointID=pointID, DT)

  #Add unique id for each point in all images
  DT[,UID := paste0(substr(file_path_sans_ext(firstFile), 1,10), "_", pointID)]

  # Start at position 2, since first image already loaded into datatable
  files <- files[2:length(files)]

  #Make datatable of all points:
  #files <- files[1:which(files == "indoor_055_det_0.pts")]
  for(file in files){
      #list <- scan(file, nmax = 68*2, fill = TRUE)
      #mat <- matrix(list, nrow = 68, ncol = 2, byrow = TRUE)
      df = read.table(file, fill = TRUE, na.strings = c("NA", "NaN"), nrows = numLines)
      DT_i = as.data.table(df)
      DT_i[,name := file]
      imageName = file_path_sans_ext(file)
      DT_i[,image := imageName]

      #Add face indicator column (IN CASE MULTIPLE FACES PER IMAGE (this is brittle. Depends on the filename to which each face's coordinates are written)):
      DT_i[,face := file_path_sans_ext(read.table(text = file, sep = "_", as.is = TRUE)$V4)]
      
      #Add point id:
      pointID <- rownames(DT_i)
      
      DT_i <- cbind(pointID=pointID, DT_i)
      
      #Add unique id for each point in all images
      DT_i[,UID := paste0(imageName, "_", pointID)]
      
      DT <- rbind(DT, DT_i)
  }
  return(DT)
}

getAnnotations = function(pathToAnnotations){
  #--------------------------------------------------------------------------------#
  #  GET COORDINATES OF ANNOTATIONS
  #--------------------------------------------------------------------------------#
  print("Getting coordinates of annotations.")
  #Now make same DT of ground truths (annotated dataset).
  setwd(pathToAnnotations)
  files <- list.files(pattern = "\\.pts$")
  firstFile = files[1]
  # Get setting by extracting beginning of name of file
  settingString = gsub( "_.*$", "", firstFile)
  firstImageID = paste0(settingString,"_001")
  numChars = nchar(firstImageID)


  #Read .pts file in:
  list <- scan(firstFile, skip = 3, nmax = 68*2)
  mat <- matrix(list, nrow = 68, ncol = 2, byrow = TRUE)
  annoDT = as.data.table(mat)
  annoDT[,name := paste0(settingString,"_001.pts")]
  annoDT[,image := paste0(settingString,"_001")]


  pointID <- rownames(annoDT)
  annoDT <- cbind(pointID=pointID, annoDT)

  #Add unique id for each point in all images
  annoDT[,UID := paste0(substr(paste0(settingString,"_001"), 1,numChars), "_", pointID)]

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
  return(annoDT)
}

computeErrors = function(DT, annoDT, writeControl = FALSE, pathInWhichToWrite = getwd()){
  #---------------------------------------------------------------------------------#
  #   COMPUTE ERRORS
  #---------------------------------------------------------------------------------#
  print("Computing errors.")

  keycols <- c("image", "UID", "pointID")

  distDT <- merge(DT,annoDT,by=keycols)

  #Annotated (ground truth) point columns are *.y (because annoDT was second object given to merge() above)

  #Get predicted coordinates:
  X1 <- distDT[,.(V1.x, V2.x)]
  #Get ground truth coordinates:
  X2 <- distDT[,.(V1.y, V2.y)]

  dist <- NULL
  for(i in 1:nrow(X1)){
      dist[i] <- euc.dist(X1[i,],X2[i,])
  }

  #RMSE:
  rmse_all_points = sqrt(mean(dist^2))
  print(paste0("UnnoRMSE between all points: ", rmse_all_points))

  distDT[,distance := dist]


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


  #compute error by face number:
  #Add new column with image and face
  distDT[,imageFace := paste0(image, "_", face)]

  imageFaces = unique(distDT[,imageFace])

  errorByFaceDT = data.table(imageFace = imageFaces)

  # Loop through all faces, computing normalized distances between predictions and annotations:
  for(imageFace_i in imageFaces){

      # Get the vector of unnormalized distances for imageFace_i:
      dist_face_i = distDT[imageFace == imageFace_i,distance]

      TEST = FALSE
      if(TEST){
          #Get predicted coordinates for face:
          X1 <- distDT[imageFace == imageFace_i,.(x_predictions, y_predictions)]
          #Get ground truth coordinates for face:
          X2 <- distDT[imageFace == imageFace_i,.(x_annotations, y_annotations)]
          
          # Make distance(/error) vector for the ith face, where each element in the vector is the distance between the annotated and ground truth point:
          dist_i <- NULL
          for(i in 1:nrow(X1)){
              dist_i[i] <- euc.dist(X1[i,],X2[i,])
          }
          # Check that dist_face_i == dist_i
          all.equal(dist_face_i, dist_i)
      }
      #RMSE:
      #rmse = sqrt(mean(dist^2))
      
      #normalize error by interocular distance of each face (distance between landmark 37 and landmark 46)
      p1 = distDT[imageFace == imageFace_i & pointID == 37, .(x_annotations, y_annotations)]
      p2 = distDT[imageFace == imageFace_i & pointID == 46, .(x_annotations, y_annotations)]

      # Compute the normalized error for each face:
      rmse = computeNormalizedRMSE(dist_face_i, p1, p2)
      
      print(paste0("Normalized RMSE between points of face ",imageFace_i, ": ", rmse))
      
      errorByFaceDT[imageFace == imageFace_i,RMSE := rmse]

      # Also normalize and save distances for each landmark:
      io_normalized_dist_face_i = normalizeDistancesByIODistance(dist_face_i, p1, p2)
      # TODO: ^THIS NEEDS TO BE TESTED.
      distDT[imageFace == imageFace_i, normalizedDistance := io_normalized_dist_face_i]
  }

  #print(software)
  # Compute Median Absolute Deviation (MAD) for all points, normalized by interocular distance:
  normalized_MAD_all_points = median(abs(errorByFaceDT[,RMSE]))
  print(paste0("Median Absolute Deviation (MAD) for all points, normalized by interocular distance:"))
  print(normalized_MAD_all_points)

  normalized_RMSE_all_points = sqrt(mean(na.omit(errorByFaceDT[,RMSE])))
  print(paste0("RMSE for all points, normalized by interocular distance:"))
  print(normalized_RMSE_all_points)




  #---------------------------------------------------------------------------------#
  #   WRITE OUTPUT
  #---------------------------------------------------------------------------------#
  if(writeControl){
      print("Writing output.")
      # Will overwrite existing files of the same names.
      #dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
      dir.create(pathInWhichToWrite, showWarnings = FALSE)
      setwd(pathInWhichToWrite)
      write.csv(distDT, "Euclidean_distance_between_predictions_and_annotations.csv")
      write.csv(normalized_MAD_all_points, "normalized_MAD_between_all_predictions_and_annotations.csv")
      write.csv(normalized_RMSE_all_points, "interoccular_normalized_RMSE_between_all_predictions_and_annotations.csv")
      write.csv(errorByFaceDT, "interoccular_normalized_RMSE_between_predictions_and_annotations_by_face.csv")
  }

}

#---------------------------------------------------------------------------------#
#   MAIN FUNCTION
#---------------------------------------------------------------------------------#
main = function(){
  # Loop through settings:
  settings = c("Indoor", "Outdoor")
  for (setting in settings){
    printer("Computing errors for setting ", setting)
    # Set args:
    args = setArgs(setting)
    software = args[1]
    writeControl = args[2]
    pathToPredictions = args[3]
    pathToAnnotations = args[4]
    pathInWhichToWrite = args[5]

    # Get predictions:
    predictionsDT = getPredictions(pathToPredictions)
  
    # Get annotations:
    annotationsDT = getAnnotations(pathToAnnotations)
    
    # Compute errors between predictions and annotations:
    computeErrors(predictionsDT, annotationsDT, writeControl = TRUE, pathInWhichToWrite)
  }
}

main()
