##########################################
# SOM modeling of mouse trajectories
###########################################

setwd("~/github/MT_SOM_experiment/results/")
source("helperFunctions.R")


summaryMeasures <- read.csv("processed.csv")
rawTrajectories <- read.csv("rx.csv")
xNorm <- read.csv("nx.csv")
yNorm <- read.csv("ny.csv")

dataRaw <- cbind(summaryMeasures,rawTrajectories[,1:151],xNorm,yNorm) # only work with raw trajectories up to 3 seconds (captures 89.8% of trajectories)
length(dataRaw$rt[dataRaw$rt<3000])/length(dataRaw$rt)


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
  else if (dataRaw$rt[i] < 200 | dataRaw$rt[i] > 5000){
    outlier[i] <- 1}
  else {
    outlier[i] <- 0}
}

sum(outlier) # counts # of outliers

dataRaw$outlier <- outlier

data <- subset(dataRaw, subset=problemType=="target" & outlier==0 & operation=='+')

# draw mean trajectories over each target answer (2, 3, 4, 6, 7, 8)
# for addition

xCoords <- rep(0,606)
yCoords <- rep(0,606)
result <- rep(0,606)

for (i in 1:101){
  xCoords[i]=mean(data[data$result==2,i+162])
  yCoords[i]=mean(data[data$result==2,i+263])+1050
  result[i]=2
  
  xCoords[i+101]=mean(data[data$result==3,i+162])
  yCoords[i+101]=mean(data[data$result==3,i+263])+1050
  result[i+101]=3
  
  xCoords[i+202]=mean(data[data$result==4,i+162])
  yCoords[i+202]=mean(data[data$result==4,i+263])+1050
  result[i+202]=4
  
  xCoords[i+303]=mean(data[data$result==6,i+162])
  yCoords[i+303]=mean(data[data$result==6,i+263])+1050
  result[i+303]=6
  
  xCoords[i+404]=mean(data[data$result==7,i+162])
  yCoords[i+404]=mean(data[data$result==7,i+263])+1050
  result[i+404]=7
  
  xCoords[i+505]=mean(data[data$result==8,i+162])
  yCoords[i+505]=mean(data[data$result==8,i+263])+1050
  result[i+505]=8
}

height=mean(summaryMeasures$height)
width=mean(summaryMeasures$width)

library(ggplot2)
trajectoryData <- data.frame(xCoords,yCoords,result)
plot=ggplot(trajectoryData,aes())+geom_path(aes(x=xCoords,y=yCoords,linetype=as.factor(result)),size=0.8)+xlim(0,width)+ylim(150,height)
labels=labs(x="horizontal mouse position (pixels)",y="vertical mouse position (pixels)",linetype="Target answer")
axes=theme(axis.title=element_text(size=rel(1.4)))
classic=theme_classic(20)+theme(axis.line.x=element_line(color="black",size=0.5,linetype="solid"),axis.line.y=element_line(color="black",size=0.5,linetype="solid"))

basePlot=plot+labels+axes+classic+theme(legend.position="none")

pos2=0.1*width+0.08*width*2
pos3=0.1*width+0.08*width*3
pos4=0.1*width+0.08*width*4
pos6=0.1*width+0.08*width*6
pos7=0.1*width+0.08*width*7
pos8=0.1*width+0.08*width*8

basePlot+geom_segment(aes(x=0.1*width,y=0.89*height,xend=0.9*width,yend=0.89*height))+annotate("text",x=c(pos2,pos3,pos4,pos6,pos7,pos8),y=rep(0.92*height,6),label=c("2","3","4","6","7","8"),size=6)+annotate("text",x=c(0.1*width,0.9*width),y=rep(0.92*height,2),label=c("0","10"),size=6)+annotate("text",x=0.5*width,y=1050,label="Target answer from addition",size=8)



# draw mean trajectories over each target answer (2, 3, 4, 6, 7, 8)
# for subtraction

data <- subset(dataRaw, subset=problemType=="target" & outlier==0 & operation=='-')

xCoords <- rep(0,606)
yCoords <- rep(0,606)
result <- rep(0,606)

for (i in 1:101){
  xCoords[i]=mean(data[data$result==2,i+162])
  yCoords[i]=mean(data[data$result==2,i+263])+1050
  result[i]=2
  
  xCoords[i+101]=mean(data[data$result==3,i+162])
  yCoords[i+101]=mean(data[data$result==3,i+263])+1050
  result[i+101]=3
  
  xCoords[i+202]=mean(data[data$result==4,i+162])
  yCoords[i+202]=mean(data[data$result==4,i+263])+1050
  result[i+202]=4
  
  xCoords[i+303]=mean(data[data$result==6,i+162])
  yCoords[i+303]=mean(data[data$result==6,i+263])+1050
  result[i+303]=6
  
  xCoords[i+404]=mean(data[data$result==7,i+162])
  yCoords[i+404]=mean(data[data$result==7,i+263])+1050
  result[i+404]=7
  
  xCoords[i+505]=mean(data[data$result==8,i+162])
  yCoords[i+505]=mean(data[data$result==8,i+263])+1050
  result[i+505]=8
}

height=mean(summaryMeasures$height)
width=mean(summaryMeasures$width)

library(ggplot2)
trajectoryData <- data.frame(xCoords,yCoords,result)
plot=ggplot(trajectoryData,aes())+geom_path(aes(x=xCoords,y=yCoords,linetype=as.factor(result)),size=0.8)+xlim(0,width)+ylim(150,height)
labels=labs(x="horizontal mouse position (pixels)",y="vertical mouse position (pixels)",linetype="Target answer")
axes=theme(axis.title=element_text(size=rel(1.4)))
classic=theme_classic(20)+theme(axis.line.x=element_line(color="black",size=0.5,linetype="solid"),axis.line.y=element_line(color="black",size=0.5,linetype="solid"))

basePlot=plot+labels+axes+classic+theme(legend.position="none")

pos2=0.1*width+0.08*width*2
pos3=0.1*width+0.08*width*3
pos4=0.1*width+0.08*width*4
pos6=0.1*width+0.08*width*6
pos7=0.1*width+0.08*width*7
pos8=0.1*width+0.08*width*8

basePlot+geom_segment(aes(x=0.1*width,y=0.89*height,xend=0.9*width,yend=0.89*height))+annotate("text",x=c(pos2,pos3,pos4,pos6,pos7,pos8),y=rep(0.92*height,6),label=c("2","3","4","6","7","8"),size=6)+annotate("text",x=c(0.1*width,0.9*width),y=rep(0.92*height,2),label=c("0","10"),size=6)+annotate("text",x=0.5*width,y=1050,label="Target answer from subtraction",size=8)


data <- subset(dataRaw, subset=problemType=="target" & outlier==0 & operation=='+')

# draw mean trajectories over each target answer (2, 3, 4, 6, 7, 8) SEPARATELY (just change target($result) for each graph)
# for addition

xCoords <- rep(0,202)
yCoords <- rep(0,202)
operation <- rep(0,202)
data <- subset(dataRaw,subset=problemType=="target" & outlier==0 & result==8)

for (i in 1:101){
  xCoords[i]=mean(data[data$operation=='+',i+162])
  yCoords[i]=mean(data[data$operation=='+',i+263])+1050
  operation[i]='addition'
  
  xCoords[i+101]=mean(data[data$operation=='-',i+162])
  yCoords[i+101]=mean(data[data$operation=='-',i+263])+1050
  operation[i+101]='subtraction'
}

height=mean(summaryMeasures$height)
width=mean(summaryMeasures$width)

library(ggplot2)
trajectoryData <- data.frame(xCoords,yCoords,operation)
plot=ggplot(trajectoryData,aes())+geom_path(aes(x=xCoords,y=yCoords,linetype=as.factor(operation)),size=0.8)+xlim(0,width)+ylim(150,height)
labels=labs(x="horizontal mouse position (pixels)",y="vertical mouse position (pixels)",linetype="operation")
axes=theme(axis.title=element_text(size=rel(1.4)))
classic=theme_classic(20)+theme(axis.line.x=element_line(color="black",size=0.5,linetype="solid"),axis.line.y=element_line(color="black",size=0.5,linetype="solid"))

basePlot=plot+labels+axes+classic+theme(legend.position=c(0.25,0.25))

pos2=0.1*width+0.08*width*2
pos3=0.1*width+0.08*width*3
pos4=0.1*width+0.08*width*4
pos6=0.1*width+0.08*width*6
pos7=0.1*width+0.08*width*7
pos8=0.1*width+0.08*width*8

basePlot+geom_segment(aes(x=0.1*width,y=0.89*height,xend=0.9*width,yend=0.89*height))+annotate("text",x=c(pos2,pos3,pos4,pos6,pos7,pos8),y=rep(0.92*height,6),label=c("2","3","4","6","7","8"),size=6)+annotate("text",x=c(0.1*width,0.9*width),y=rep(0.92*height,2),label=c("0","10"),size=6)+annotate("text",x=0.5*width,y=1050,label="Target answer",size=8)


########################################
## test SOM effect
########################################

data <- subset(dataRaw, subset=problemType=="target" & outlier==0)

agg=aggregate(error~subject_nr+operation+result,data=data,FUN="mean") # endpoint error performance data aggregated by subject

summary=summarySEwithin(agg,measurevar="error",withinvars=c("operation","result"),idvar="subject_nr")

ggplot(summary,aes(x=result,y=error,shape=operation))+geom_line(aes(group=operation,linetype=operation))+geom_point(size=4)+labs(x="Target answer",y="Mean endpoint error")+theme(legend.title=element_text(face="bold",size=rel(1.3)),legend.text=element_text(size=rel(1.3)))+theme(axis.title=element_text(face="bold",size=rel(1.3)))+theme(axis.text.x=element_text(size=rel(1.3)))+theme(axis.text.y=element_text(size=rel(1.3)))+theme_classic(20)+theme(axis.line.x=element_line(color="black",size=0.5,linetype="solid"),axis.line.y=element_line(color="black",size=0.5,linetype="solid"))+geom_errorbar(width=0.1,aes(ymin=error-ci,ymax=error+ci)) 


endpoint.aov=aov(error~as.factor(result)*as.factor(operation)+Error(as.factor(subject_nr)/(as.factor(result)*as.factor(operation))),data=agg)
summary(endpoint.aov)
print(model.tables(endpoint.aov,"means"),digits=6)


##########
## regression analyses
##

data <- subset(dataRaw, subset=problemType=="target" & outlier==0)
xAxis <- seq(from=0,to=3000,by=20)

## Stage 1:  result as sole predictor (holistic model?)
## predictor = result
## DV = horizontal mouse position

betaWeights <- rep(0,151)  # we have 151 time slices from 0 to 3000 ms in 20 ms increments

for (i in 1:151){
  model <- lm(scale(data[,i+11])~scale(result),data=data)
  betaWeights[i] <- model$coefficients[2]
}

plot(x=xAxis,y=betaWeights)


## Stage 2:  result and operands as predictors

betaWeights1 <- rep(0,151)  # we have 151 time slices from 0 to 3000 ms in 20 ms increments
betaWeights2 <- rep(0,151)  # operand 1
betaWeights3 <- rep(0,151)  # operand 2

for (i in 1:151){
  model <- lm(scale(data[,i+11])~scale(result)+scale(operand1)+scale(operand2),data=data)
  betaWeights1[i] <- model$coefficients[2]
  betaWeights2[i] <- model$coefficients[3]
  betaWeights3[i] <- model$coefficients[4]
}

# build ggplot dataframe
xCoords=rep(xAxis,3)
yCoords=c(betaWeights1,betaWeights2,betaWeights3)
predictor=c(rep("answer",151),rep("operand 1",151),rep("operand 2",151))

plotData<-data.frame(xCoords,yCoords,predictor)
plot=ggplot(plotData,aes())+geom_path(aes(x=xCoords,y=yCoords,linetype=predictor),size=0.8)
plot


## Stage 3:  result and operation and operands as predictors

betaWeights1 <- rep(0,151)  # we have 151 time slices from 0 to 3000 ms in 20 ms increments
betaWeights2 <- rep(0,151)  # operation
betaWeights3 <- rep(0,151)  # operand 1
betaWeights4 <- rep(0,151)  # operand 2

for (i in 1:151){
  model <- lm(scale(data[,i+11])~scale(result)+scale(as.numeric(operation))+scale(operand1)+scale(operand2),data=data)
  betaWeights1[i] <- model$coefficients[2]
  betaWeights2[i] <- model$coefficients[3]
  betaWeights3[i] <- model$coefficients[4]
  betaWeights4[i] <- model$coefficients[5]
}

# build ggplot dataframe
xCoords=rep(xAxis,4)
yCoords=c(betaWeights1,betaWeights2,betaWeights3,betaWeights4)
predictor=c(rep("answer",151),rep("operation",151),rep("operand 1",151),rep("operand 2",151))

plotData<-data.frame(xCoords,yCoords,predictor)
plot=ggplot(plotData,aes())+geom_path(aes(x=xCoords,y=yCoords,linetype=predictor),size=0.8)
plot
