########run_analysis 
######## programming project 

setwd("C:/Users/YabbaMan/Documents/fun/coursera - cleaning data Apr 2015")
library(dplyr)
library(tidyr)
library(stringr)

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
# first counted lines in each file, with MSDOS command
# example
# c:\> type c:\windows\win.ini | find /c /v "~~~"
# from https://isc.sans.edu/forums/diary/Finding+Files+and+Counting+Lines+at+the+Windows+Command+Prompt/2244/
#
# test = 2947, train = 7352, use as arguments for number lines in readLines 
# 
# parse into columns with separate() 
#
# read column names from featuresTXT - provided as guide to data set
#   select subset of featuresTXT which contain "std" or "mean"
#   save subset of indices 
# 
# select subset of columns, delete others (lacking "std", "mean")
# add label names to each data frame, will be identical
#
# read subject  identifiers from y_train.txt, y_test.txt
# read activity identifiers from subject_train.txt, subject_test.txt
# add subject & activity columns to each test & train
#
# merge test & train into single data frame 
#
# compute mean for each column

#read in firsst 10 lines, examine data structure
# its all fixed-width 
xTrain <- readLines("C:/Users/YabbaMan/Documents/fun/coursera - cleaning data Apr 2015/UCI HAR Dataset/train/X_train.txt",50)

#read in firsst 10 lines, examine data structure
# also fixed-width, 16 characters per column
xTest <- readLines("C:/Users/YabbaMan/Documents/fun/coursera - cleaning data Apr 2015/UCI HAR Dataset/test/X_test.txt",50)
#?data.frame
#nchar(xTrain[1] )/16 #[1] 561 columns, confirmed in features.txt


######## read in features from text file, find which variables to keep
featuresTXT <- readLines("C:/Users/YabbaMan/Documents/fun/coursera - cleaning data Apr 2015/UCI HAR Dataset/features.txt")
featuresTXT <- data.frame(featuresTXT ) # convert to data frame for separate()
featuresTXT <- separate(featuresTXT, "featuresTXT", c("number", "name"), " ")
featuresTXT$number <-NULL # delete first column for numbers
featuresTXT <- featuresTXT$name  #convert back to vector

keepCols <- grep("std|mean", featuresTXT , ignore.case = TRUE) # find column numbers containing std|mean
keepNames <-str_extract(featuresTXT , ".*([s|S]td|[m|M]ean).*") # find variable names containing std|mean


#xTrain <- read.fwf("C:/Users/YabbaMan/Documents/fun/coursera - cleaning data Apr 2015/UCI HAR Dataset/train/X_train.txt",
#      widths = rep(16,561),col.names =featuresTXT  ) 


xTrain <- data.frame(xTrain,stringsAsFactors = FALSE) #convert to data frame full of string
xTest <- data.frame(xTest ,stringsAsFactors = FALSE) #convert to data frame full of string

#str(xTrain )
#str(xTest )
#str(featuresTXT)
#?separate
#seeIfItWorks <-separate(xTrain[1], "xTrain", c("emptyFillerColumn", featuresTXT), "[ ]+")

######### separate by spaces AND add variable names ######### 
xTrain<-separate(xTrain, "xTrain", c("emptyFillerColumn", featuresTXT), "[ ]+") 
xTest<-separate(xTest, "xTest", c("emptyFillerColumn", featuresTXT), "[ ]+")

xTrain$emptyFillerColumn <- NULL; xTest$emptyFillerColumn <- NULL # delete first column since its empty

#seeIfItWorks <- separate(xTrain[1], "xTrain", seq(1,562), "[ ]+")
#seeIfItWorks[,1] <- NULL # delete first column since its empty
#seeIfItWorks[1:5,1:5] #inspect first 5 rows & columns, YES it works
#str(seeIfItWorks)
#names(seeIfItWorks)

xTrain <- xTrain[,keepCols] # subset only cols with std|mean
xTest <- xTest[,keepCols] # subset only cols with std|mean
names(xTrain ) # confirm that only std|mean variables remain
names(xTest )

######## read subject and activity files#######
subjectColumnTrain<- readLines("UCI HAR Dataset/train/subject_train.txt",50) # read lines from subject file
activityColumnTrain<- readLines("UCI HAR Dataset/train/y_train.txt",50)# read lines from activity label file
subjectColumnTest<- readLines("UCI HAR Dataset/test/subject_test.txt",50) # read lines from subject file
activityColumnTest<- readLines("UCI HAR Dataset/test/y_test.txt",50)# read lines from activity label file

#str(subjectColumn)
#seeIfItWorks<-cbind(seeIfItWorks,subjectColumn) # add subject  column to main data frame
#seeIfItWorks<-cbind(seeIfItWorks,activityColumn)# add activity column to main data frame

xTrain<-cbind(xTrain,subjectColumnTrain)# add subject column to train data frame
xTrain<-cbind(xTrain,activityColumnTrain)# add activity column to train data frame
xTest<-cbind(xTest,subjectColumnTest)# add subject column to train data frame
xTest<-cbind(xTest,activityColumnTest)# add activity column to train data frame

names(xTest) # confirm only remaining std|mean variables + subject + activity

#names(xTest) ==names(xTrain) # shows last 2 columns not same

######## set last columns to same name for both train and test ########
names(xTrain)[87] <- "subjectColumn"
names(xTrain)[88] <- "activityColumn"
names(xTest)[87] <- "subjectColumn"
names(xTest)[88] <- "activityColumn"

xTotal <-rbind (xTrain,xTest) # combine both into one frame
str(xTotal ) # check structure of combined frame

################### complete down to here ###############

#str( rbind (xTrain,xTest))  # bind together train & test frames

?read.table
?readLines
read.table(file, header = FALSE, sep = "", quote = "\"'",
           dec = ".", numerals = c("allow.loss", "warn.loss", "no.loss"),
           row.names, col.names, as.is = !stringsAsFactors,
           na.strings = "NA", colClasses = NA, nrows = -1,

xTrainTwo <- read.table("UCI HAR Dataset/train/X_train.txt",nrows = 5,colClasses = "character",comment.char = "")
#!watch out! read.table converts to numbers and loses precision
#can get away without converting to numbers in initial stage, since most columsn will be deleted
str( xTrainTwo )
xTrainTwo <- xTrainTwo[,keepCols ]
print(object.size(xTrainTwo ), units="Kb") #initially 231.5 Kb, then 36.8 Kb after subsetting
# for 1000 lines, 8820.4 Kb, estimate whole file >>> 8820.4 *7.3 = 64388.92

xTrainTwo <- readLines("UCI HAR Dataset/train/X_train.txt",n = 10)
xTrainTwo <- NULL

1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING
count lines in: 
test = 2947?  seems too low, maybe lower since test NOT train
train = 7352

