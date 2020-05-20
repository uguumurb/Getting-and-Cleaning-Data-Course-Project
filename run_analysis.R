##Getting and Cleaning Data Course Project
#Author: U.Burentugs
#Script description
# 1-Merges the training and the test sets to create one data set.
# 2-Extracts only the measurements on the mean and standard deviation for each measurement.
# 3-Uses descriptive activity names to name the activities in the data set
# 4-Appropriately labels the data set with descriptive variable names.
# 5-From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)
library(tidyr)
library(data.table)

## Creating folder for data
if (!file.exists("dataFolder")) { 
        dir.create("dataFolder") }
#Downloading the dataset
if (!file.exists("./dataFolder/rawdata.zip")){
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "./dataFolder/rawdata.zip", method="curl")
}  
#Unzipping the zip file
if (!file.exists("./dataFolder/UCI HAR Dataset")) { 
        unzip("./dataFolder/rawdata.zip",exdir = "./dataFolder")
}
#Importing activity label data
activitylabel=fread("./dataFolder/UCI HAR Dataset/activity_labels.txt",col.names = c("ActivityLabel","Activity"))

#Importing features data
features=fread("./dataFolder/UCI HAR Dataset/features.txt",col.names = c("Index","FeatureVariables"))
#Finding measurements only on mean and std
meanstdIndex=grep("-mean\\(|-std\\(",features$FeatureVariables)
#Extracting variable names and cleanig the names
cleanVarNames=features$FeatureVariables[meanstdIndex]
cleanVarNames=gsub("-"," ",cleanVarNames)
cleanVarNames=gsub("[()]","",cleanVarNames)       

#Importing the data from Train
trainSubject=fread("./dataFolder/UCI HAR Dataset/train/subject_train.txt")
trainActivity=fread("./dataFolder/UCI HAR Dataset/train/y_train.txt")
trainVariable=fread("./dataFolder/UCI HAR Dataset/train/x_train.txt")
#Combining the subject, activity and variable tables
combinedTrain=cbind(trainSubject,trainActivity,select(trainVariable,meanstdIndex))


#Importing the data from Test
testSubject=fread("./dataFolder/UCI HAR Dataset/test/subject_test.txt")
testActivity=fread("./dataFolder/UCI HAR Dataset/test/y_test.txt")
testVariable=fread("./dataFolder/UCI HAR Dataset/test/x_test.txt")
#Combining the subject, activity and variable tables
combinedTest=cbind(testSubject,testActivity,select(testVariable,meanstdIndex))

#Combining test and train data
wholeData=rbind(combinedTest,combinedTrain)

#Renaming column names
colnames(wholeData)=c("Subject","Activity",cleanVarNames)

#Replacing activity label numbers to Activity names
wholeData$Activity=factor(wholeData$Activity,levels=activitylabel$ActivityLabel,labels = activitylabel$Activity)

#Changing subject field to factor
wholeData$Subject=factor(wholeData$Subject)
#Creating unique ID for each observation
wholeData$observationID=seq.int(nrow(wholeData))
#Moving ID to first column
wholeData=select(wholeData,c(ncol(wholeData),1:(ncol(wholeData)-1)))
                 
#Tidying up the data
tidyData=wholeData %>% 
        gather("measurements","values",-Subject,-Activity,-observationID) %>%
        separate(measurements,c("Signal","AnalysisType","Direction")) %>%
        spread(AnalysisType,values)
#Creating 2nd Tidy data set
groupedData=group_by(tidyData,Subject,Activity,Signal,Direction)
tidyData2=summarise(groupedData,AverageMean=mean(mean),AverageSTD=mean(std))
#Sorting data
tidyData2=arrange(tidyData2,Subject,Activity,Signal,Direction)
write.table(tidyData2, "2ndTidyTable.txt", row.names = FALSE, quote = FALSE)
