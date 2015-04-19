## Read the training data set
xtrain<- read.csv("train/X_train.txt", sep="", header=FALSE)
nrow(xtrain)
ncol(xtrain)

class(xtrain)
colnames(xtrain)
class(xtrain$X)

ytrain<-read.csv("train/y_train.txt", sep="", header=FALSE)
xtrain$activity<-ytrain[,1]

nrow(ytrain)
nrow(xtrain)

subtrain<- read.csv("train/subject_train.txt",sep="",header=FALSE)
nrow(subtrain)

xtrain$subid<-subtrain[,1]
ncol(xtrain)


###################################################################################
## Read the test dataset

xtest<- read.csv("test/X_test.txt", sep="", header=FALSE)

ytest<-read.csv("test/y_test.txt", sep="", header=FALSE)
xtest$activity<-ytest[,1]

subtest<- read.csv("test/subject_test.txt",sep="",header=FALSE)
xtest$subid<-subtest[,1]

###################################################################################
## Read the feature names
features<-read.table("features.txt", header=FALSE, sep="")
class(features[,2])
features[,2]<- as.character(features[,2])

###################################################################################
## Merge the train and test data sets

data1<-rbind(xtrain,xtest)
rownames(data1)
colnames(data1)[1:561]<-features[,2]
colnames(data1)

l<-c(grep("mean()", names(data1)), grep("std()", names(data1)), 562, 563)
colnames(data1)[l]

data2<- data1[, l]
nrow(data2)
ncol(data2)

str(data2)

nrow(data2)
ncol(data2)

names(data2)[80]<-"activityid"

library(reshape2)
data3<-melt(data2,id=c("activityid", "subid"), measure.vars=names(data2)[1:79])

data4 <- aggregate(value ~ activityid + subid + variable, data3, mean)

head(data4)
tail(data4)

write.table(data4, "tidy-long.txt", quote=FALSE)

data5 <- dcast(data4, activityid + subid ~ variable)
nrow(data5)
ncol(data5)


write.table(data5, "tidy-wide.txt", quote=FALSE)














