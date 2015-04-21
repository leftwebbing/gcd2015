########run_analysis 
######## programming project

setwd("C:/Users/YabbaMan/Documents/fun/coursera - cleaning data Apr 2015")
library(dplyr)
library(tidyr)

#
#You should create one R script called run_analysis.R that does the following. 
#
#  1  Merges the training and the test sets to create one data set.
#  2  Extracts only the measurements on the mean and standard deviation for each measurement. 
#  3  Uses descriptive activity names to name the activities in the data set
#  4  Appropriately labels the data set with descriptive variable names. 
#  5  From the data set in step 4, creates a second, independent tidy data set 
#     with the average of each variable for each activity and each subject.
#
#Good luck!

######## ######## overall plan ######## ########
# load files with read.lines (yes, this takes a LOOOOONG time but appears as the only way)
# parse into columns with separate() 
#
# read subject identifiers from subject_train.txt
# read activity .......... from subject_train.txt
#
# merge files together
# 
# read column names from featuresTXT - provided as guide to data set
#   select subset of featuresTXT which contain "std" or "mean"
#   save subset of indices 
#
# select subset of columns, delete others (lacking "std", "mean")
#

#read in firsst 10 lines, examine data structure
xTest <- readLines("C:/Users/YabbaMan/Documents/fun/coursera - cleaning data Apr 2015/UCI HAR Dataset/test/X_test.txt",50)
# its all fixed-width 

#read in firsst 10 lines, examine data structure
xTrain <- readLines("C:/Users/YabbaMan/Documents/fun/coursera - cleaning data Apr 2015/UCI HAR Dataset/train/X_train.txt",50)
# also fixed-width, 16 characters per column
?data.frame
nchar(xTrain[1] )/16 #[1] 561 columns, confirmed in features.txt



#read in features from text file
featuresTXT <- readLines("C:/Users/YabbaMan/Documents/fun/coursera - cleaning data Apr 2015/UCI HAR Dataset/features.txt")
featuresTXT <- data.frame(featuresTXT ) # convert to data frame for separate()
featuresTXT <- separate(featuresTXT, "featuresTXT", c("number", "name"), " ")
head(featuresTXT )
str(featuresTXT )
featuresTXT$number <-NULL
featuresTXT <- featuresTXT$name  #convert back to vector
?grep
grep(featuresTXT )

keepCols <- grep("std|mean", featuresTXT , ignore.case = TRUE) # find columns with std|mean
#grep(".*(std|mean).*", featuresTXT , ignore.case = TRUE)

library(stringr)
datesMatched <-
str_extract(featuresTXT , ".*([s|S]td|[m|M]ean).*") # yes


#xTrain <- read.fwf("C:/Users/YabbaMan/Documents/fun/coursera - cleaning data Apr 2015/UCI HAR Dataset/train/X_train.txt",
      widths = rep(16,561),col.names =featuresTXT  ) 


#read.fwf(file, widths, header = FALSE, sep = "\t",
#         skip = 0, row.names, col.names, n = -1,
#         buffersize = 2000, fileEncoding = "", ...)

xTrain <- data.frame(xTrain,stringsAsFactors = FALSE) #convert to data frame full of string
str(xTrain )
str(featuresTXT)
?separate
seeIfItWorks <-separate(xTrain[1], "xTrain", c("emptyFillerColumn", featuresTXT), "[ ]+")
#seeIfItWorks <- separate(xTrain[1], "xTrain", seq(1,562), "[ ]+")
seeIfItWorks[,1] <- NULL # delete first column since its empty
seeIfItWorks[1:5,1:5] #inspect first 5 rows & columns, YES it works

str(seeIfItWorks[,keepCols] )# subset only cols with std|mean

#xTest <- read.csv("C:/Users/YabbaMan/Documents/fun/coursera - cleaning data Apr 2015/UCI HAR Dataset/test/X_test.txt",200)# NOT a csv
#xTrain <- read.csv("C:/Users/YabbaMan/Documents/fun/coursera - cleaning data Apr 2015/UCI HAR Dataset/train/X_train.txt") # NOT a csv



1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING
