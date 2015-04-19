###################################################################################
## Read the training data set

xtrain<- read.csv("train/X_train.txt", sep="", header=FALSE)

ytrain<-read.csv("train/y_train.txt", sep="", header=FALSE)
xtrain$activityid<-ytrain[,1]

subtrain<- read.csv("train/subject_train.txt",sep="",header=FALSE)
xtrain$subid<-subtrain[,1]

###################################################################################
## Read the test dataset

xtest<- read.csv("test/X_test.txt", sep="", header=FALSE)

ytest<-read.csv("test/y_test.txt", sep="", header=FALSE)
xtest$activityid<-ytest[,1]

subtest<- read.csv("test/subject_test.txt",sep="",header=FALSE)
xtest$subid<-subtest[,1]

###################################################################################
## Read the feature names

features<-read.table("features.txt", header=FALSE, sep="")
features[,2]<- as.character(features[,2])

###################################################################################
## Merge the train and test data sets

data1<-rbind(xtrain,xtest)
colnames(data1)[1:561]<-features[,2]

###################################################################################
## Choose the columns which represent mean using grep on mean() and std deviation
## using grep on std() => total of 66 measurements

l<-c(grep("mean\\(\\)", names(data1)), grep("std\\(\\)", names(data1)), 562, 563)

data2<- data1[, l]

###################################################################################
## Melt the dataset to a long form with each measurement and the corresponding
## value falling in the columns "variable" and "value"

library(reshape2)
data3<-melt(data2,id=c("activityid", "subid"), measure.vars=names(data2)[1:66])

###################################################################################
## Use the aggregate function on each "value" by activityid/subid/variable

data4 <- aggregate(value ~ activityid + subid + variable, data3, mean)

###################################################################################
## Remove the - and () from the variables so that they become potential valid R column names

data4$variable<-gsub("-", "", data4$variable)
data4$variable<-gsub("\\(\\)", "", data4$variable)


###################################################################################
## Write out the dataset to a txt file. This is the long form.
## Number of rows =
## 30 (number of subjects) * 6 (number of activities) * 66 (number of measurements) = 11880
## Number of cols = 4 (activityid, subid, variable, value)
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ NOTE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
## This is NOT the final data set submitted. I used the wide form created in the following step.

write.table(data4, "tidy-long.txt", quote=FALSE)

###################################################################################
## Cast the data frame to write out each "variable" as an attribute with the 
## corresonding "value"

data5 <- dcast(data4, activityid + subid ~ variable)

###################################################################################
## Read the activity names

activities<-read.table("activity_labels.txt", header=FALSE, sep="", 
                       col.names=c("activityid", "activity"))

###################################################################################
## Merge activities with data5

data6<- merge(data5, activities)
data6<- data6[,-1]

###################################################################################
## Write out the dataset to a text file. This is the wide form.
## Number of rows =
## 30 (number of subjects) * 6 (number of activities) = 180
## Number of columns = 68 (66 measurements + 1 subjectid + 1 activity)

write.table(data6, "tidy-wide.txt", row.name=FALSE, quote=FALSE)

###################################################################################
## To read the data back into R, use the following code:

wideData<-read.csv("tidy-wide.txt", header=TRUE, sep="")

###################################################################################
## Sanity checks on the data read into R:

ncol(wideData) # Returns 68
nrow(wideData) # Returns 180
names(wideData) # Returns the below
# [1] "subid"                    "fBodyAccJerkmeanX"        "fBodyAccJerkmeanY"       
# [4] "fBodyAccJerkmeanZ"        "fBodyAccJerkstdX"         "fBodyAccJerkstdY"        
# [7] "fBodyAccJerkstdZ"         "fBodyAccMagmean"          "fBodyAccMagstd"          
# [10] "fBodyAccmeanX"            "fBodyAccmeanY"            "fBodyAccmeanZ"           
# [13] "fBodyAccstdX"             "fBodyAccstdY"             "fBodyAccstdZ"            
# [16] "fBodyBodyAccJerkMagmean"  "fBodyBodyAccJerkMagstd"   "fBodyBodyGyroJerkMagmean"
# [19] "fBodyBodyGyroJerkMagstd"  "fBodyBodyGyroMagmean"     "fBodyBodyGyroMagstd"     
# [22] "fBodyGyromeanX"           "fBodyGyromeanY"           "fBodyGyromeanZ"          
# [25] "fBodyGyrostdX"            "fBodyGyrostdY"            "fBodyGyrostdZ"           
# [28] "tBodyAccJerkMagmean"      "tBodyAccJerkMagstd"       "tBodyAccJerkmeanX"       
# [31] "tBodyAccJerkmeanY"        "tBodyAccJerkmeanZ"        "tBodyAccJerkstdX"        
# [34] "tBodyAccJerkstdY"         "tBodyAccJerkstdZ"         "tBodyAccMagmean"         
# [37] "tBodyAccMagstd"           "tBodyAccmeanX"            "tBodyAccmeanY"           
# [40] "tBodyAccmeanZ"            "tBodyAccstdX"             "tBodyAccstdY"            
# [43] "tBodyAccstdZ"             "tBodyGyroJerkMagmean"     "tBodyGyroJerkMagstd"     
# [46] "tBodyGyroJerkmeanX"       "tBodyGyroJerkmeanY"       "tBodyGyroJerkmeanZ"      
# [49] "tBodyGyroJerkstdX"        "tBodyGyroJerkstdY"        "tBodyGyroJerkstdZ"       
# [52] "tBodyGyroMagmean"         "tBodyGyroMagstd"          "tBodyGyromeanX"          
# [55] "tBodyGyromeanY"           "tBodyGyromeanZ"           "tBodyGyrostdX"           
# [58] "tBodyGyrostdY"            "tBodyGyrostdZ"            "tGravityAccMagmean"      
# [61] "tGravityAccMagstd"        "tGravityAccmeanX"         "tGravityAccmeanY"        
# [64] "tGravityAccmeanZ"         "tGravityAccstdX"          "tGravityAccstdY"         
# [67] "tGravityAccstdZ"          "activity"  
