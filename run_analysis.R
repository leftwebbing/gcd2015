########run_analysis 
######## programming project 

setwd("C:/Users/YabbaMan/Documents/fun/coursera - cleaning data Apr 2015") # my home working directory
library(dplyr)
library(tidyr)
library(stringr)

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
# compute average of each variable for each activity and each subject
# mean for each column

# read test set, fixed-width as character, 2947 lines
xTest <- readLines("C:/Users/YabbaMan/Documents/fun/coursera - cleaning data Apr 2015/UCI HAR Dataset/test/X_test.txt",2947)
#read training set, 7352 lines
xTrain <- readLines("C:/Users/YabbaMan/Documents/fun/coursera - cleaning data Apr 2015/UCI HAR Dataset/train/X_train.txt",7352)

#nchar(xTrain[1] )/16 #[1] 561 columns, confirmed in features.txt

######## read in features from text file, find which variables to keep
featuresTXT <- readLines("UCI HAR Dataset/features.txt") # read file
featuresTXT <- data.frame(featuresTXT ) # convert to data frame for separate()
featuresTXT <- separate(featuresTXT, "featuresTXT", c("number", "name"), " ") # separate into number, name columns
featuresTXT$number <-NULL # delete first column for numbers
featuresTXT <- featuresTXT$name  #convert back to vector

keepCols <- grep("std|mean", featuresTXT , ignore.case = TRUE) # find column numbers containing std|mean
keepNames <-str_extract(featuresTXT , ".*([s|S]td|[m|M]ean).*") # find variable names containing std|mean
keepNames <-keepNames[!is.na(keepNames)]
#str(keepCols )

xTrain <- data.frame(xTrain,stringsAsFactors = FALSE) #convert to data frame full of string
xTest <- data.frame(xTest ,stringsAsFactors = FALSE) #convert to data frame full of string

#str(xTrain )
#str(xTest )
#str(featuresTXT)
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
# test = 2947, train = 7352 from MSDOS command line 
subjectColumnTrain<- readLines("UCI HAR Dataset/train/subject_train.txt",7352) # read lines from subject file
activityColumnTrain<- readLines("UCI HAR Dataset/train/y_train.txt",7352)# read lines from activity label file
subjectColumnTest<- readLines("UCI HAR Dataset/test/subject_test.txt",2947) # read lines from subject file
activityColumnTest<- readLines("UCI HAR Dataset/test/y_test.txt",2947)# read lines from activity label file

#str(subjectColumn)
#seeIfItWorks<-cbind(seeIfItWorks,subjectColumn) # add subject  column to main data frame
#seeIfItWorks<-cbind(seeIfItWorks,activityColumn)# add activity column to main data frame

xTrain<-cbind(xTrain,subjectColumnTrain)  # add subject  column to train data frame
xTrain<-cbind(xTrain,activityColumnTrain) # add activity column to train data frame
xTest<-cbind(xTest,subjectColumnTest)     # add subject  column to test  data frame
xTest<-cbind(xTest,activityColumnTest)    # add activity column to test  data frame

names(xTest) # confirm only remaining std|mean variables + subject + activity

######## set last columns to same name for both train and test ########
names(xTrain)[87] <- "subject"
names(xTrain)[88] <- "activity"
names(xTest)[87] <- "subject"
names(xTest)[88] <- "activity"

xTotal <-rbind (xTrain,xTest) # combine both into one frame
str(xTotal ) # check structure of combined frame

######### step 5, compute averages "of each variable for each activity and each subject"
# this description is ambiguous - does it mean calculating averages of every combination
# of variable, activity and subject? That requires 86*6*30 = 15480 entries.

tidyAverages <- matrix(nrow =86*6*30,ncol =4)# initialize vector
colnames(tidyAverages ) <- c("variable name", "activity", "subject", "variable average") # set column names

count <-0 # initialize couter
for (variableN in 1:86){ # run only first 5 activities in testing, then set back to 86 for real run TODO
  for (activityN in 1:6){ # 6 activities
    for (subjectN in 1:30) { # # run only first 5 subjects in testing, then set back to 30 for real run TODO
      count <-count +1 #increment counter

      tidyAverages[count ,1] <- keepNames[variableN ] # store var name into col 1
      tidyAverages[count ,2] <- activityN # store activity # into col 2
      tidyAverages[count ,3] <- subjectN # store subject # into col 3
      ####### compute average of variable ####### 
      # subset values matching variable, activity, subject
      subVar <- xTotal[xTotal$subject ==subjectN  & xTotal$activity ==activityN  , variableN] # subset 
      subVar <- as.numeric( subVar ) # convert to numeric FINALLY since only required here
      if(length(subVar) == 0) tidyAverages[count ,4] <- NA # if empty, store NA
        else tidyAverages[count ,4] <- mean(subVar ) # otherwise store average into col 4
      
      }
    }
  }


#activityNames <- c("walking", "walkUp", "walkDown", "sit", "stand", "lay") # vector of names corresponding to levels 1:6
#levels(xTotal$activity) <- activityNames # set levels of activity to names from prior line 
#names(xTotal)[87] <- "subject"
#names(xTotal)[88] <- "activity"
#xTotal[,89] <-NULL

# output tidy data frame will contain
# rows: selected variables containing mean|std [1:86] 
# columns: activity [1:6]  + subject [1:30] 

######### write tidy data set #########
write.table(xTotal,file = "tidyDataSet2.txt", row.name=FALSE)
write.table(tidyAverages,file = "tidyAverages2.txt", row.name=FALSE)




################### notes ###############

#1 WALKING
#2 WALKING_UPSTAIRS
#3 WALKING_DOWNSTAIRS
#4 SITTING
#5 STANDING
#6 LAYING
#count lines in: 
#test = 2947?  seems too low, maybe lower since test NOT train
#train = 7352
