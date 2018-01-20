# Script plots errors (distances between predictions and annotations) by each landmark location
# Authored by Sean Hendryx. seanmhendryx@email.arizona.edu

#--------------------------------------------------------------------------------#
#  LOAD PACKAGES
#--------------------------------------------------------------------------------#
packages = c('ggplot2', 'data.table')
lapply(packages, library, character.only = TRUE)


#--------------------------------------------------------------------------------#
#  DEFINE FUNCTIONS
#--------------------------------------------------------------------------------#
#improved print function:
printer <- function(string, var){
  print(paste0(string, " ", var))
}


#--------------------------------------------------------------------------------#
#  READ IN DATA
#--------------------------------------------------------------------------------#
softwares = c("OpenFace")
settings = c("Indoor", "Outdoor")
inputFilePaths = c("/Users/seanmhendryx/Data/landmarks/experiments/OpenFace/errorResults/01_Indoor/normalized_error_for_each_landmark/Euclidean_distance_between_predictions_and_annotations.csv",
  "/Users/seanmhendryx/Data/landmarks/experiments/OpenFace/errorResults/02_Outdoor/normalized_error_for_each_landmark/Euclidean_distance_between_predictions_and_annotations.csv")


DT = as.data.table(read.csv(inputFilePaths[1]))
DT[,software := softwares[1]]
DT[,setting := settings[1]]

i = 1
for(software in softwares){
  for(setting in settings){
    if (i != 1) {
      DT_i = as.data.table(read.csv(inputFilePaths[i]))
      DT_i[,software := software]
      DT_i[,setting := setting]
      DT = rbind(DT, DT_i)
    }
    i = i + 1
  }
}

#--------------------------------------------------------------------------------#
#  MAKE PLOTS
#--------------------------------------------------------------------------------#
# Plot errors by landmark:
p = ggplot(data = DT,  mapping = aes(x = reorder(pointID, as.numeric(pointID)), y = normalizedDistance, color = software)) + geom_boxplot() + theme_bw() + 
  labs(title = "Euclidean Distance by Facial Landmark", y = "Normalized Distance (% of interocular distance)", x = "Facial Landmark ID") + theme(plot.title = element_text(hjust = 0.5)) #center the plot title
p

# Same as above but removing outliers:
outThresh = 3*sd(DT[,normalizedDistance])
p = ggplot(data = DT[normalizedDistance<=outThresh], mapping = aes(x = reorder(pointID, as.numeric(pointID)), y = normalizedDistance, color = software)) + geom_boxplot() + theme_bw() + 
  labs(title = "Euclidean Distance by Facial Landmark with Outliers Removed", y = "Normalized Distance (% of interocular distance)", x = "Facial Landmark ID") + theme(plot.title = element_text(hjust = 0.5)) #center the plot title
p = p + facet_grid(.~setting)



p = ggplot(data = DT, mapping = aes(x = normalizedDistance, color = software, fill  = software)) + geom_density() + theme_bw()
p = p + facet_grid(. ~ setting)
p


# eye points:
eyePoints = 37:48

# face boundary:
faceBoundary = 1:17

mouth = 49:68

removeOutliers = FALSE
if (removeOutliers){
  DT = DT[normalizedDistance < outThresh]
}

# EYES:
pEye = ggplot(data = DT[pointID %in% eyePoints],  mapping = aes(x = reorder(pointID, as.numeric(pointID)), y = normalizedDistance, color = software)) + geom_boxplot() + theme_bw() + 
  labs(title = "Euclidean Distance by Facial Landmark for Eye Points", y = "Normalized Distance (% of interocular distance)", x = "Facial Landmark ID") + theme(plot.title = element_text(hjust = 0.5)) #center the plot title
pEye

# FACE OUTLINE
dev.new()
pFB = ggplot(data = DT[pointID %in% faceBoundary],  mapping = aes(x = reorder(pointID, as.numeric(pointID)), y = normalizedDistance, color = software)) + geom_boxplot() + theme_bw() + 
  labs(title = "Euclidean Distance by Facial Landmark for Face Outline Points", y = "Normalized Distance (% of interocular distance)", x = "Facial Landmark ID") + theme(plot.title = element_text(hjust = 0.5)) #center the plot title
pFB

dev.new()
# MOUTH:
pM = ggplot(data = DT[pointID %in% mouth],  mapping = aes(x = reorder(pointID, as.numeric(pointID)), y = normalizedDistance, color = software)) + geom_boxplot() + theme_bw() + 
  labs(title = "Euclidean Distance by Facial Landmark for Mouth Points", y = "Normalized Distance (% of interocular distance)", x = "Facial Landmark ID") + theme(plot.title = element_text(hjust = 0.5)) #center the plot title
pM

