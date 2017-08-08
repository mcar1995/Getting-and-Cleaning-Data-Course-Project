#Getting and cleaning data project
library(dplyr)
library(reshape2)

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
newfile <- "course3_dataset.zip"

if(!file.exists(newfile)) {
    download.file(fileURL, destfile = newfile, method = "curl")
    unzip(newfile, exdir= "course3projectdata")
}

path <- file.path("course3projectdata", "UCI HAR Dataset")
files <- list.files(path, recursive = TRUE)

#Read files and get labels
#Read subject files

train_subject <- read.table(file.path(path, "train", "subject_train.txt"))
test_subject <- read.table(file.path(path, "test", "subject_test.txt"))

#Read activity labels 

train_activity <- read.table(file.path(path, "train", "y_train.txt"))
test_activity <- read.table(file.path(path, "test", "y_test.txt"))

#read feature labels

train_featureset <- read.table(file.path(path, "train", "X_train.txt"))
test_featureset <- read.table(file.path(path, "test", "X_test.txt"))

#merge training and test sets

Activity <- rbind(test_activity, train_activity)
Subject <- rbind(test_subject, train_subject)
Feature <- rbind(test_featureset, train_featureset)

# Rename column names

featureLabels <- read.table(file.path(path, "features.txt"))
activity_names <- read.table(file.path(path, "activity_labels.txt"))

colnames(Features) <- featureLabels[,2]
colnames(Subject) <- "subject"
colnames(Activity) <- activity_names[,2]

#merge data to one dataset
dataset <- cbind(Subject, Activity, Feature)

#Extract only measurements of mean and standard deviation
data_measurements <- dataset[ , grep("mean|std|subject|activity", colnames(dataset))]

#Use descriptive activity names to name the activities in dataset
data_measurements$activity[data_measurements$activity == 1] <- "Walking"
data_measurements$activity[data_measurements$activity == 2] <- "Walking Upstairs"
data_measurements$activity[data_measurements$activity == 3] <- "Walking Downstairs"
data_measurements$activity[data_measurements$activity == 4] <- "Sitting"
data_measurements$activity[data_measurements$activity == 5] <- "Laying"


#Appropriately label the data set with descriptive variable names.
#Use Gsub to rename the variables

names(data_measurements) <- gsub("Acc", "Acceleration", names(data_measurements))
names(data_measurements) <- gsub("^t", "Time", names(data_measurements))
names(data_measurements) <- gsub("^f", "Frequency", names(data_measurements))
names(data_measurements) <- gsub("BodyBody", "Body", names(data_measurements))
names(data_measurements) <- gsub("Freq", "Frequency", names(data_measurements))
names(data_measurements) <- gsub("Mag", "Magnitude", names(data_measurements))

#From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

tidydata <- data_measurements %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))

# Saving file 

write.table(tidydata, file = "final_tidydata.txt", sep = ";")
