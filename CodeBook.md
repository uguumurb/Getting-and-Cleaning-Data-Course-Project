CodeBook for Getting and Cleaning Data Course Project
================


## Data Set Information

Raw data is from [ UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

##Variables

There are 16 different measurements, each has direction. For each measurement/direction mean and std are available. All of them are separated into different rows per tidy data concept.


* fBodyAcc
* fBodyAccJerk
* fBodyAccMag
* fBodyBodyAccJerkMag
* fBodyBodyGyroJerkMag
* fBodyBodyGyroMag
* fBodyGyro
* tBodyAcc
* tBodyAccJerk
* tBodyAccJerkMag
* tBodyAccMag
* tBodyGyro
* tBodyGyroJerk
* tBodyGyroJerkMag
* tBodyGyroMag
* tGravityAcc
* tGravityAccMag



## Activity Labels

Activities are available in Activity column as factor with following labels and levels

Level   |       Activity
--------|-------------------------
1       |       WALKING 
2       |       WALKING_UPSTAIRS   
3       |       WALKING_DOWNSTAIRS  
4       |       SITTING   
5       |       STANDING   
6       |       LAYING   
