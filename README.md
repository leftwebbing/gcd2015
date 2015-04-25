# gcd2015
Coursera Getting and Cleaning Data 2015 programming assignment

The script in this repository loads a collection of files from the UCI Machine Learning Repository. Before loading the entire files, the number of lines in each data set were counted using a MS DOS command. 
For example, the command

c:\> type c:\windows\win.ini | find /c /v "~~"

searches through all lines of win.ini, and counts each line without the string "~~". The DOS command indicated 7352 and 2947 lines in the test and train sets respectively. The R command "readLines" is known to run faster when the total number of lines in a source file are known in advance. 

First, the program reads the two main data sets as character-only vectors. The files are large, and can be read faster by reading them as a raw format instead of converting them to numeric values. After reading the files, each line of the respective test and train sets contain rows of a single long varaible. 
The data set in this lab contains a file "features.txt" listing descriptive variable names. This file was read into a vector, and parsed into 561 individual names. 

To parse the raw data into individual columns, "separate()" was then run on these data frames. The separate() command is part of the "tidyr" package available through CRAN databases. At the outset of this project, two obvious options appeared for reading the data sets. The first option was "read.fwf()" which reads data from a file, and separates it into columns based on the column widths of entries. The second option was reading the data sets as raw characters with "readLines" and then running "separate" to parse them into columns. The second option offered the advantage to automatically name the columns, and was selected for the project.

The separate() command was run with a regular expression to collect groups of spaces into a single separator. The separate() command parsed data frames into columns, based on the previously loaded "features.txt" file. Both data files are cushioned by leading spaces, which was converted into an empty column by separate(). Before proceeding, the empty column was deleted.

According to the project goal #2, only variables with "mean" or "std" in their name were selected for further analysis. A twofold approach extracted both the column numbers and descriptive names for later subsetting. "grep()" extracted the numbers, and "str_extract()" from the "stringr" R library extracted the names. 

With the known column numbers, each of the train and test data frames were subsetted to extract only variables with "mean" or "std" in their name. The subsets were then joined using "rbind()" into an intermediate data frame named "xTotal." This data frame contained all values of the selected variables, in character format.

Project goal #5 requests to compute averages "of each variable for each activity and each subject." This description is ambiguous, and could mean calculating averages of every combination of variable, activity and subject. That interpretation would require 86*6*30 = 15480 entries. This number of rows is manageable, but was only run once at the very end of the project to avoid using extra time.

The averages of each variable were computed with a nested for() loop along variable, activity and subject. Inside the innermost loop, a subset of xTotal was extracted, which represented the data values of a specific variable, activity and subject. This vector was converted to numeric values and averages, then stored in the output table "tidyAverages." Surprisingly, this was the only step in the entire project that required converting raw character strings into numeric values. 

tidyAverages columns:
"variable name", "activity", "subject", "variable average"

After completing the nested for() loop, both the cleaned data and averages were stored in two text files, named "tidyDataSet2.txt" and "tidyAverages2.txt" respectively.

========References========

Lichman, M. (2013). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml]. Irvine, CA: University of California, School of Information and Computer Science. http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#

https://isc.sans.edu/forums/diary/Finding+Files+and+Counting+Lines+at+the+Windows+Command+Prompt/2244/

http://127.0.0.1:21080/library/tidyr/html/separate.html

http://127.0.0.1:21080/library/stringr/html/str_extract.html
