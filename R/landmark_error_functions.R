# Author = Sean Hendryx for the IVI-Lab at the University of Arizona

# Helper functions for facial landmark analyses


##Load packages:
packages = c('ggplot2', 'data.table', 'dplyr', 'tools', 'metrics')#, 'plotly', 'phia', 'xtable', 'Morpho')
lapply(packages, library, character.only = TRUE)
# Must source helper functions (currently coded assuming that the helper function file is in the same directory from which the script is run):


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
    TEST = TRUE
    if(TEST){
        if(sum(na.omit(distVec))/n != rmse){
            warning("Difference in RMSE, check NA handling of function computeNormalizedRMSE.")
        }
    }
    #normalize error by interoccular distance
    return(normalizeErrorBYIODist(rmse, p1, p2))
}

normalizeDistancesByIODistance <- function(dist_face_i, p1, p2){
    # Normalizes the values in dist_face_i by dividing by the 2d Euclidean distance between p1 and p2
    # @param dist_face_i: a vector of distances between annotations and ground truth points
    # @param p1, p2: vector of ground truth coordinates. The distance between p1 and p2 is the normalization constant
    
    d_outer = sqrt((p1[[1]] - p2[[1]])^2 + (p1[[2]] - p2[[2]])^2 )
    io_normalized_dist_face_i = dist_face_i/d_outer
    retrun(io_normalized_dist_face_i)
}

#not in:
'%!in%' <- function(x,y){
    !('%in%'(x,y))
}
