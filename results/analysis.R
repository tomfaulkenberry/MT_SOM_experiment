##########################################
# SOM modeling of mouse trajectories
###########################################

setwd("~/github/MT_SOM_experiment/results/")

summaryMeasures <- read.csv("processed.csv")
trajectories <- read.csv("rx.csv")

dataRaw <- cbind(summaryMeasures,trajectories)

hist(dataRaw$rt)


# build vector of outliers according to rules in Dotan & Dehaene (2013)
outlier <- rep(0,length(dataRaw$rt)) # start empty vector to denote outlier status

for (i in 1:length(dataRaw$rt)){
  subject <- dataRaw$subject_nr[i]
  target <- dataRaw$result[i]
  quantilePerSubject <- quantile(dataRaw$endpoint[dataRaw$subject_nr==subject & dataRaw$result==target])
  IQR <- quantilePerSubject[4]-quantilePerSubject[2]
  if (dataRaw$endpoint[i] < quantilePerSubject[2] & quantilePerSubject[2]-dataRaw$endpoint[i]>1.5*IQR){
    outlier[i] <- 1}
  else if (dataRaw$endpoint[i] > quantilePerSubject[4] & dataRaw$endpoint[i]-quantilePerSubject[4]>1.5*IQR){
    outlier[i] <- 1}
  else if (dataRaw$rt[i] < 200){
    outlier[i] <- 1}
  else {
    outlier[i] <- 0}
}

dataRaw$outlier <- outlier

data <- subset(dataRaw, subset=problemType=="target" & outlier==0)
