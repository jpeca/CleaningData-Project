Getting and Cleaning Data Course Project 
========================================

author: Predrag Jovanovic

date: "Monday, November 17, 2014"

General
=======

The goal of the project  is to prepare tidy data that can be used for later analysis. Source data for the project represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained on 
This link](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

R script
========
First part of R script downolad data. Data is in zip package, so we need to unpack it, before read it into R. If not exist script create subfolder project and unpack data into it. During unpacking a new folder UCI HAR Dataset will be created with two subfolders test and train with test and train data respectivly.  

Next section of R script work with train data set  - trainDT
1.  Load train data ./train/x_train into R as data frame
2.  Load column names for data  from separate file features.txt and add them to data frame. According good practice names are converted to lower case and bracket are  removed from column names. 
3.  Remove columns from data frame witch is not mean or starndard deviation. E.g. remain only columns which contain "-mean" or "-std" in description. As number of columns in original data frame is large, we used grepl funcion to compute logical vector which column to remain in data frame. 
  
```{r}
colcond <- grepl("-mean|-std", names(trainDT)) # create filter by column names
trainDT <- trainDT[, colcond]   
```
4.  Add activity column from separate source file y_train
5.  Add subject column from separate source file subject_train

The  same steps 1-5 are apply also to test data set - testDT. 

After that  training and the test sets are merged to create one data set allDT.
In new data set activity codes (as factors) are replaced with descriptive activity names (from activity_labels.txt)
```{r}
actDT <- read.table("activity_labels.txt", sep=" ", header=FALSE , stringsAsFactors=FALSE)
levels(allDT$activity) <- actDT[,2]
```
Also I found that column names contain fbodybody and assume that is error and replace with fbody with gsub


At the and  independent data set  avgDF is created with the average of each variable for each activity and each subject.
Library reshape2 is used and combination of melt and dcast
```{r}
tempDF <- melt(allDT, id.vars=c("subject", "activity"))
avgDF <- dcast(tempDF, subject+activity ~ variable, mean)
```
Final data  set are export in txt file result.txt 
