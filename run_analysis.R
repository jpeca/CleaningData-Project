## Create project folder, download and extract files
setwd ("D:/CleaningData") # Project folder
if (!file.exists("project1")){dir.create("project")}
setwd("project")
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile="getdata.zip")
unzip("getdata.zip")
setwd("UCI HAR Dataset")
#
# Read column labels from separate file
labels <- read.table("features.txt", sep=" ", header=FALSE , stringsAsFactors=FALSE)
#
## Training data frame
trainDT <- read.table("./train/X_train.txt", header=FALSE)
colnames(trainDT) <- tolower(gsub("\\(\\)", "", labels[,2]))  # double backslash for esc in windows
# Remove all  columns but mean and std
colcond <- grepl("-mean|-std", names(trainDT)) # create filter by column names
trainDT <- trainDT[, colcond]   
# Add activity column to train data frame
DY <- read.table("./train/y_train.txt", header=FALSE)
trainDT$activity  = as.factor(DY[,1])
# Add subject to train data frame
DS <- read.table("./train/subject_train.txt", header=FALSE)
trainDT$subject <- as.factor(DS[,1])
#
## Test data frame
testDT <- read.table("./test/x_test.txt", header=FALSE)
colnames(testDT) <-  tolower(gsub("\\(\\)", "", labels[,2]))
# Remove all  columns but mean and std
colcond <- grepl("-mean|-std", names(testDT)) # create filter by column names
testDT <- testDT[, colcond]   
# Add activity column with activity names
DY <- read.table("./test/y_test.txt", header=FALSE)
testDT$activity  = as.factor(DY[,1])
# Add subject to test data set
DS <- read.table("./test/subject_test.txt", header=FALSE)
testDT$subject <- as.factor(DS[,1])
#
# Merge train and test data
allDT <- rbind(trainDT, testDT)
rm(list =c( "testDT", "trainDT", "DS", "DY")) # clear memory
# Convert activity code to labels
actDT <- read.table("activity_labels.txt", sep=" ", header=FALSE , stringsAsFactors=FALSE)
levels(allDT$activity) <- actDT[,2]
# independent t data set with the average of each variable for each activity and each subject
library(reshape2)
tempDF <- melt(allDT, id.vars=c("subject", "activity"))
avgDF <- dcast(tempDF, subject+activity ~ variable, mean)
# Create txt file 
write.table(avgDF, file="result.txt", row.names=FALSE)
