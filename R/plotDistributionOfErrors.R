library(data.table)
library(ggplot2)

rms = function(errors){
  rmse = sqrt(mean(na.omit(errors)))
  return(rmse)
}

DTFPP = as.data.table(read.csv("/Users/seanmhendryx/Data/landmarks/experiments/Face++/errorResults/indoor/interoccular_normalized_RMSE_between_predictions_and_annotations_by_face.csv"))
DTFPP[,dataset := "Face++"]
DTFPP[,setting := "indoor"]

DTOF = as.data.table(read.csv("/Users/seanmhendryx/Data/landmarks/experiments/OpenFace/errorResults/indoor/interoccular_normalized_RMSE_between_predictions_and_annotations_by_face.csv"))
DTOF[,dataset := "OpenFace"]
DTOF[,setting := "indoor"]

DT = rbind(DTOF, DTFPP)

DTFPP = as.data.table(read.csv("/Users/seanmhendryx/Data/landmarks/experiments/Face++/errorResults/outdoor/interoccular_normalized_RMSE_between_predictions_and_annotations_by_face.csv"))
DTFPP[,dataset := "Face++"]
DTFPP[,setting := "outdoor"]

DT = rbind(DT, DTFPP)

DTOF = as.data.table(read.csv("/Users/seanmhendryx/Data/landmarks/experiments/OpenFace/errorResults/outdoor/interoccular_normalized_RMSE_between_predictions_and_annotations_by_face.csv"))
DTOF[,dataset := "OpenFace"]
DTOF[,setting := "outdoor"]

DT = rbind(DT, DTOF)


p = ggplot(data = DT, mapping = aes(x = RMSE, color = dataset, fill  = dataset)) + geom_density() + theme_bw()
p = p + facet_grid(. ~ setting)
p

h = ggplot(data = DT, mapping = aes(x = RMSE, color = dataset, fill  = dataset)) + geom_histogram() + theme_bw()
h = h + facet_grid(. ~ setting)
h


rmseOF = rms(DT[dataset == "OpenFace", RMSE])
print("OpenFace RMSE of interoccular normalized distance between predictions and annotations:")
print(rmseOF)

rmseFPP = rms(DT[dataset == "Face++", RMSE])
print("Face++ RMSE of interoccular normalized distance between predictions and annotations:")
print(rmseFPP)
