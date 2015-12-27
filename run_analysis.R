#if you want to run this script, uncomment the line below and 
#set your own working directory to point to UCI HAR Dataset

#setwd("path-to-UCI HAR Dataset/UCI HAR Dataset")

library(dplyr)




# *********************************************
# step 1
# ceate a merged dataset


# read in the file with the data from test directory

xTestFileName <- "./test/X_test.txt"
xTestDataFrame <- read.table(xTestFileName, header = FALSE, sep = "", fill=TRUE)

#inspect the file
str(xTestDataFrame)

# data.frame':	2947 obs. of  561 variables:, all numeric

# as we can see from the above output of the str function, the nr. of columns in the dataframe
# coresponds to the number of indicated features = column names/meaning of the column data
# as mentioned in the features.txt file


# ***********************************************
#read in the file features.txt wich includes the original column names

colNamesFileName <- "./features.txt"
colNamesDataFrame <- read.table(colNamesFileName,header = FALSE, sep = "", fill=TRUE, colClasses ="character")

str(colNamesDataFrame)
#'data.frame':	561 obs. of  2 variables:
#  $ V1: chr  "1" "2" "3" "4" ...
#$ V2: chr  "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X"

# it is useful to see the definition of make.names() function, 
# it explains what syntactically valid name consists of 

#extract the column names to a vector

colNamesVec <- colNamesDataFrame[,2]
str(colNamesVec)
colNamesVec[10]

# [1] "tBodyAcc-max()-X"

#process the names in the vector, in order to remove undesired characters lile "-"
colNamesVec <- make.names(colNamesVec)

colNamesVec[10]
#[1] "tBodyAcc.max...X"

#now attach these column names to the xTestDataFrame
names(xTestDataFrame) <- colNamesVec
names(xTestDataFrame)

#******************************************

#now add to the xTestDataFrame two more columns:
# 1- the persons who performed the activies from file "./test/subject_test.txt"
# 2 # the activities performed from file "./test/y_test.txt"

#read in the subject_test.txt file
#file with persons who where in the test group
#each person is identified by a nr.

subjectTestFileName <- "./test/subject_test.txt"
subjectTestDF <- read.table(subjectTestFileName, header = FALSE, sep = " " )

#inspect the file
str(subjectTestDF)
# data.frame':	2947 obs. of  1 variable:
# $ V1: int  2 2 2 2 2 2 2 2 2 2 ...

#attach a proper column name
names(subjectTestDF) <- c("personID")
names(subjectTestDF)

# read in the y_test.txt file
# each row in this file represents an activity for wich data where collected in the X_test.txt file
# the 2 files are related by row-nr.

activityTestFileName <- "./test/y_test.txt"
activityTestDF <- read.table(activityTestFileName, header = FALSE, sep = " " )

#inspect the dataframe
str(activityTestDF)
#'data.frame':	2947 obs. of  1 variable:
#  $ V1: int  5 5 5 5 5 5 5 5 5 5 ...

#attach a proper column name
names(activityTestDF) <- c("activityID")
names(activityTestDF)

#check the values
unique(activityTestDF["activityID"])

# bind the two columns
newTestDF <- data.frame(subjectTestDF, activityTestDF, xTestDataFrame)

#inspect the new DF
str(newTestDF)
#'data.frame':	2947 obs. of  563 variables:
#  $ personID                            : int  2 2 2 2 2 2 2 2 2 2 ...
# $ activityID                          : int  5 5 5 5 5 5 5 5 5 5 ...
# $ tBodyAcc.mean...X                   : num  0.257 0.286 0.275 0.27 0.275 ...
# $ tBodyAcc.mean...Y                   : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...

names(newTestDF)
#[1] "personID"                             "activityID"                          
#[3] "tBodyAcc.mean...X"                    "tBodyAcc.mean...Y"                   
#[5] "tBodyAcc.mean...Z"                    "tBodyAcc.std...X"                    
#[7] "tBodyAcc.std...Y"                     "tBodyAcc.std...Z"                    
#[9] "tBodyAcc.mad...X"                     "tBodyAcc.mad...Y"                    
#[11] "tBodyAcc.mad...Z"                     "tBodyAcc.max...X"     

#check for NAs in newTestDF
all(colSums(is.na(newTestDF)) == 0)
#[1] TRUE

#check the activityID column
unique(newTestDF["activityID"])

#*****************************************************************
# read in the training data

#read in the file X_train.txt

xTrainFileName <- "./train/X_train.txt"
xTrainDF <- read.table(xTrainFileName, sep="", fill=TRUE, header = FALSE)

#inspect the file
str(xTrainDF)

#'data.frame':	7352 obs. of  561 variables:
#  $ V1  : num  0.289 0.278 0.28 0.279 0.277 ...
#$ V2  : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
#$ V3  : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...

#attach column names to the dataframe
names(xTrainDF) <- colNamesVec
names(xTrainDF)

#read in the file with the person IDs = subject_train.txt
subjectTrainFileName <- "./train/subject_train.txt"
subjectTrainDF <- read.table(subjectTrainFileName, sep="", header=FALSE)

#inspect the dataframe
str(subjectTrainDF)
#'data.frame':	7352 obs. of  1 variable:
#  $ V1: int  1 1 1 1 1 1 1 1 1 1 ...

#attach a column name
names(subjectTrainDF) <- c("personID")
names(subjectTrainDF)

#read in the file with the activity IDs: y_train.txt
yTrainFileName <- "./train/y_train.txt"
yTrainDF <- read.table(yTrainFileName, sep="", header=FALSE)

#inspect the dataframe
str(yTrainDF )
#'data.frame':	7352 obs. of  1 variable:
 # $ V1: int  5 5 5 5 5 5 5 5 5 5 ...

#attach a proper name
names(yTrainDF) <- c("activityID")
names(yTrainDF)
# [1] "activityID"

#add the 2 columns to xTrainDF

newTrainDF <- data.frame(subjectTrainDF, yTrainDF,xTrainDF )
str(newTrainDF)
#'data.frame':	7352 obs. of  563 variables:
#  $ personID                            : int  1 1 1 1 1 1 1 1 1 1 ...
#$ activityID                          : int  5 5 5 5 5 5 5 5 5 5 ...
#$ tBodyAcc.mean...X                   : num  0.289 0.278 0.28 0.279 0.277 ...
#$ tBodyAcc.mean...Y                   : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
#$ tBodyAcc.mean...Z                   : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...

#check for NAs in newTrainDF
all(colSums(is.na(newTrainDF)) == 0)
#[1] TRUE

#check the activityID column
unique(newTrainDF["activityID"])


#*****************************************************
#*****************************************************
#step 2
#merge the 2 dataframes newTestDF and newTrainDF

mergedDF <- merge(newTestDF, newTrainDF, all=TRUE)
str(mergedDF)
#'data.frame':	10299 obs. of  563 variables:
#  $ personID                            : int  1 1 1 1 1 1 1 1 1 1 ...
#$ activityID                          : int  1 1 1 1 1 1 1 1 1 1 ...
#$ tBodyAcc.mean...X                   : num  0.156 0.18 0.19 0.202 0.204 ...
#$ tBodyAcc.mean...Y                   : num  -0.04961 -0.0178 -0.0389 -0.00904 -0.03051 ...

#use an rbind method, as recommende by the TA
#this method is much faster than the first one

mergedDF <- rbind_list(newTestDF, newTrainDF)
mergedDF <- as.data.frame(mergedDF)
str(mergedDF)

#'data.frame':	10299 obs. of  563 variables:
#  $ personID                            : int  2 2 2 2 2 2 2 2 2 2 ...
#$ activityID                          : int  5 5 5 5 5 5 5 5 5 5 ...
#$ tBodyAcc.mean...X                   : num  0.257 0.286 0.275 0.27 0.275 ...
#$ tBodyAcc.mean...Y                   : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
#$ tBodyAcc.mean...Z                   : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...



#*******************************************
#step 2

# subset of the original combined raw data set in which the only 
# measurement variables contain either mean or standard deviation (std) in their names;

#find the indices of the columns that contain "mean" or "std" at any position in their names,
#but not meanFreq columns


vecMeanStd <- grep("personID|activityID|mean\\.|std", names(mergedDF))
str(vecMeanStd)
#int [1:68] 1 2 3 4 5 6 7 8 43 44 ...

#verify the result column-names for the indices above
names(mergedDF)[vecMeanStd]
# [1] "personID"                    "activityID"                  "tBodyAcc.mean...X"          
# [4] "tBodyAcc.mean...Y"           "tBodyAcc.mean...Z"           "tBodyAcc.std...X"           
# [7] "tBodyAcc.std...Y"            "tBodyAcc.std...Z"            "tGravityAcc.mean...X"   


#alternativ:  extract mean/std cols as logical vector
#vecMeanStdLogic <- grepl("personID|activityID|mean\\.|std", names(mergedDF))
#str(vecMeanStdLogic)

#now subset the mergedDF and store the result to meansStdDF

meansStdDF <- mergedDF[,vecMeanStd ]
str(meansStdDF)
#'data.frame':	10299 obs. of  68 variables:
# $ personID                   : int  1 1 1 1 1 1 1 1 1 1 ...
# $ activityID                 : int  1 1 1 1 1 1 1 1 1 1 ...
#$ tBodyAcc.mean...X          : num  0.156 0.18 0.19 0.202 0.204 ...
#$ tBodyAcc.mean...Y          : num  -0.04961 -0.0178 -0.0389 -0.00904 -0.03051 ...
#$ tBodyAcc.mean...Z          : num  -0.1129 -0.0393 -0.0987 -0.0791 -0.1371 ...



#*********************************************
#*********************************************
#step 3:
# replace the numeric codes for activity 
# with the corresponding alphabetic value from activity_labels.txt
# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING

#read in the file with the explicit activities: activity_labels.txt

activityLabelsFileName <- "./activity_labels.txt"
activityLabelsDF <- read.table(activityLabelsFileName, sep="", header=FALSE, stringsAsFactors = FALSE)
str(activityLabelsDF)
#'data.frame':	6 obs. of  2 variables:
#$ V1: int  1 2 3 4 5 6
#$ V2: chr  "WALKING" "WALKING_UPSTAIRS" "WALKING_DOWNSTAIRS" "SITTING" ...

#attach column names
names(activityLabelsDF) <-c("activityID", "activityName")
names(activityLabelsDF)


#before merging,
#analyze the activityID column: see whta distinct values are in there
unique(meansStdDF["activityID"])

#now merge the meansStdDF and activityLabelsDF by the activityID column
#meansStdActivityDF <- merge(activityLabelsDF, meansStdDF, by = "activityID", all.y = TRUE)

meansStdActivityDF <- merge(activityLabelsDF, meansStdDF, by = "activityID")

str(meansStdActivityDF)
#'data.frame':	10299 obs. of  69 variables:
#  $ activityID                 : int  1 1 1 1 1 1 1 1 1 1 ...
#$ activityName               : chr  "WALKING" "WALKING" "WALKING" "WALKING" ...
#$ personID                   : int  26 29 29 29 29 29 29 29 29 29 ...
#$ tBodyAcc.mean...X          : num  0.231 0.331 0.376 0.233 0.236 ...
#$ tBodyAcc.mean...Y          : num  -0.0177 -0.0185 -0.0247 -0.0345 -0.0144 ...


#analyze the result
sum(is.na(meansStdActivityDF["activityName"]))
# [1] 0

#delete the activityID column, it is redundand
meansStdActivityDF2 <- meansStdActivityDF[,-1]

str(meansStdActivityDF2)
#'data.frame':	10299 obs. of  68 variables:
#  $ activityName               : chr  "WALKING" "WALKING" "WALKING" "WALKING" ...
#$ personID                   : int  26 29 29 29 29 29 29 29 29 29 ...
#$ tBodyAcc.mean...X          : num  0.231 0.331 0.376 0.233 0.236 ...
#$ tBodyAcc.mean...Y          : num  -0.0177 -0.0185 -0.0247 -0.0345 -0.0144 ...



#*************************************
#*************************************

#Step 4:
# modify the original variable names (column names) with names conforming to both the R naming standard
# and the convention introduced by the tidy data principles; domain experts would likely consider the names 
# as already easy to read but you want non-domain experts to understand the content of each column; and

colNames <- names(meansStdActivityDF2)
newColNames <- gsub("\\.", "", colNames )
newColNames <- gsub("mean", "Mean", newColNames)
newColNames <- gsub("std", "Std", newColNames)

str(newColNames)
# chr [1:68] "activityName" "personID" "tBodyAccMeanX" "tBodyAccMeanY" "tBodyAccMeanZ" ...

#assign the new columnnames to the dataframe meansStdActivityDF2

names(meansStdActivityDF2) <- newColNames
names(meansStdActivityDF2)
#[1] "activityName"             "personID"                 "tBodyAccMeanX"           
#[4] "tBodyAccMeanY"            "tBodyAccMeanZ"            "tBodyAccStdX"            
#[7] "tBodyAccStdY"             "tBodyAccStdZ"             "tGravityAccMeanX"        
#[10] "tGravityAccMeanY"         "tGravityAccMeanZ"         "tGravityAccStdX"    


#*****************************************************************
#*****************************************************************
#Step 5

# create a separate tidy data set containing observations consisting of 
# study participants, 
# activities performed during the study, and a 
# computed average for each of the measurement variables.


# order the input DF meansStdActivityDF2
resultDF1 <- arrange(meansStdActivityDF2, personID)
resultDF1[1:10, 1:4]

resultDF1 <- arrange(meansStdActivityDF2, personID, activityName)
resultDF1[1:20, 1:4]

#first group the data
resultDF2 <- resultDF1 %>%  group_by(personID,activityName )
resultDF2[1:20, 1:4]

#then summarize the non-grouped columns
resultDF3 <- resultDF2 %>% summarize_each(funs(mean))
str(resultDF3)

#Classes ‘grouped_df’, ‘tbl_df’, ‘tbl’ and 'data.frame':	180 obs. of  68 variables:
#$ personID                : int  1 1 1 1 1 1 2 2 2 2 ...
# $ activityName            : chr  "LAYING" "SITTING" "STANDING" "WALKING" ...
# $ tBodyAccMeanX           : num  0.222 0.261 0.279 0.277 0.289 ...

resultDF3[1:20, 1:4]

#personID       activityName tBodyAccMeanX tBodyAccMeanY
#(int)              (chr)         (dbl)         (dbl)
#1         1             LAYING     0.2215982  -0.040513953
#2         1            SITTING     0.2612376  -0.001308288
#3         1           STANDING     0.2789176  -0.016137590
#4         1            WALKING     0.2773308  -0.017383819
#5         1 WALKING_DOWNSTAIRS     0.2891883  -0.009918505
#6         1   WALKING_UPSTAIRS     0.2554617  -0.023953149
#7         2             LAYING     0.2813734  -0.018158740
#8         2            SITTING     0.2770874  -0.015687994
#9         2           STANDING     0.2779115  -0.018420827
#10        2            WALKING     0.2764266  -0.018594920

#write out the file and read it in for test purposes

write.table(resultDF3, file = "./tidyData.txt", sep=" ", row.name=FALSE)
testDF <- read.table(file = "./tidyData.txt", sep=" ", header = TRUE,  fill=TRUE)

str(testDF)
names(testDF)
testDF[1:20, 1:4]

#write out the columnnames for the codebook
write.table(names(resultDF3), file = "./codebook.txt", sep=" ", row.name=TRUE)


