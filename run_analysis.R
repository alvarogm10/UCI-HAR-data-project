#Add libraries
library(data.table)
#Download data set 
if(!file.exists("./dataset")){
	dir.create("./dataset")
	download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="./dataset/data.zip")
	unzip(zipfile="./dataset/data.zip",exdir="./dataset")
}
if(file.exists("./dataset")){
print("Data downloaded") #Download checker
}
#Read data

#Subjects
testsub <- read.table("./dataset/UCI HAR Dataset/test/subject_test.txt")
trainsub <- read.table("./dataset/UCI HAR Dataset/train/subject_train.txt")
#Features
testft <- read.table("./dataset/UCI HAR Dataset/test/X_test.txt")
trainft <- read.table("./dataset/UCI HAR Dataset/train/X_train.txt")
#Activities
testact <- read.table("./dataset/UCI HAR Dataset/test/y_test.txt")
trainact <- read.table("./dataset/UCI HAR Dataset/train/y_train.txt")

#Merge data
subj <- rbind(testsub,trainsub)
names(subj) <- "Subject"
#Rename variables for feature 
feat <- rbind(testft,trainft)
na <- read.table("./dataset/UCI HAR Dataset/features.txt")
#Extract standard deviation and mean values from feautures
names(feat) <- na$V2
sm <- sort(c(grep("std\\(\\)",names(feat)),grep("mean\\(\\)",names(feat))))
feat <- feat[,sm]
#Rename variables for activity
acti <- rbind(testact,trainact)
names(acti) <- "Activity"
na <- read.table("./dataset/UCI HAR Dataset/activity_labels.txt")
for(i in 1:6){acti[acti==i] <- na$V2[i]}
#Combine
DT <- data.frame(subj,acti,feat)
na <- names(DT)
#Label dataset with descriptive variable names
na <- gsub("\\()","",na)
na <- gsub("^angle","Angle",na)
na <- gsub("^f","Frequency",na)
na <- gsub("^t","Time",na)
na <- gsub("Gyro"," gyroscope",na)
na <- gsub("Acc"," accelerometer",na)
na <- gsub("Mag"," magnitude",na)
na <- gsub("tBody","Time body",na)
na <- gsub("BodyBody"," body",na)
na <- gsub("B"," b",na)
na <- gsub("G"," g",na)
na <- gsub("J"," j",na)
na <- gsub("\\.\\.\\."," ",na)
na <- gsub("\\.\\.","",na)
na <- gsub("\\."," ",na)
names(DT) <- na

#Create independent data set
library(dplyr)
dt <- DT %>% group_by(Subject,Activity) %>% summarize_at(vars(na[3:68]),mean)
#Write table
write.table(dt,"dt.txt",row.name=FALSE)
