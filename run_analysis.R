## 1. Use plyr package 
library(plyr)

## 2. Create a function to download and unzip the data
download.unzip = function() {
  if (!file.exists("data")) {
    dir.create("data")
  }
  if (!file.exists("data/UCI HAR Dataset")) {
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    zipfile="data/UCI_HAR_data.zip"
    download.file(fileURL, destfile=zipfile, method="curl")
    unzip(zipfile, exdir="data")
  }
}

## 3. Create a function to read and merge the data
merge.data = function() {
  training.x <- read.table("data/UCI HAR Dataset/train/X_train.txt")
  training.y <- read.table("data/UCI HAR Dataset/train/y_train.txt")
  training.subject <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
  test.x <- read.table("data/UCI HAR Dataset/test/X_test.txt")
  test.y <- read.table("data/UCI HAR Dataset/test/y_test.txt")
  test.subject <- read.table("data/UCI HAR Dataset/test/subject_test.txt")

  merged.x <- rbind(training.x, test.x)
  merged.y <- rbind(training.y, test.y)
  merged.subject <- rbind(training.subject, test.subject)

  return(list(x=merged.x, y=merged.y, subject=merged.subject))
}

## 4. Calculate the mean and standard deviation for each measurement.
mean.std = function(df) {
  features <- read.table("data/UCI HAR Dataset/features.txt")

  mean <- sapply(features[,2], function(x) grepl("mean()", x, fixed=T))
  std <- sapply(features[,2], function(x) grepl("std()", x, fixed=T))

  edf <- df[, (mean | std)]
  colnames(edf) <- features[(mean | std), 2]

  return(edf)
}

## 5. Use descriptive activity names to name the activities in the data set
activities = function(df) {
  colnames(df) <- "activity"
  df$activity[df$activity == 1] = "WALKING"
  df$activity[df$activity == 2] = "WALKING_UPSTAIRS"
  df$activity[df$activity == 3] = "WALKING_DOWNSTAIRS"
  df$activity[df$activity == 4] = "SITTING"
  df$activity[df$activity == 5] = "STANDING"
  df$activity[df$activity == 6] = "LAYING"
  return(df)
}

## 6. Creat a dataframe combining mean and std, acitivities and subjects
bind.data <- function(x, y, subjects) {
  return(cbind(x, y, subjects))
}

## 7. Create an independent tidy dataset with the average of each variable for each activity and each subject.
clean.data = function(df) {
  tidy <- ddply(df, .(subject, activity), function(x) colMeans(x[,1:60]))
  return(tidy)
}

## 8. Call the functions in 1 to 7 to create the final output and save the clean data
  download.unzip()
  merge.all <- merge.data()
  cx <- mean.std(merge.all$x)
  cy <- activities(merge.all$y)
  colnames(merge.all$subject) <- c("subject")
  combined <- bind.data(cx, cy, merge.all$subject)
  tidy <- clean.data(combined)
  write.table(tidy, "UCI_HAR_Clean_Data.txt", sep="\t")
