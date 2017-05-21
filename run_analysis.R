# 1. Merges the training and test sets to create one data set. 


library(dplyr)

#Download and unzip files

if(!file.exists("./data")){dir.create("./data")}
fileURL<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile="./data/Dataset.zip",method="curl")

unzip(zipfile="./data/Dataset.zip",exdir="./data")

path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)

###Read in the data files

ActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

SubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
SubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)


FeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

#### Combine test and trainingsset

Activity <- rbind(ActivityTest, ActivityTrain)
Subject <- rbind(SubjectTest, SubjectTrain)
Features <- rbind(FeaturesTest, FeaturesTrain)

### rename the columnnames

featureLabels <- read.table(file.path(path_rf, "features.txt"),header = FALSE)

colnames(Features) <- featureLabels[,2]
colnames(Subject) <- "subjectID"
colnames(Activity) <- "activity"

### Comebine the data to get one dataset

Data <- cbind(Subject, Activity, Features)


### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
##### Mean and std (plus of course subjectID and activity)

data.mean.std <- Data[, grep("mean|std|subjectID|activity",colnames(Data))]


#### 3. Uses descriptive activity names to name the activities in the data set

data.mean.std$activity[data.mean.std$activity == 1] <- "Walking"
data.mean.std$activity[data.mean.std$activity == 2] <- "Walking Upstairs"
data.mean.std$activity[data.mean.std$activity == 3] <- "Walking Downstairs"
data.mean.std$activity[data.mean.std$activity == 4] <- "Sitting"
data.mean.std$activity[data.mean.std$activity == 5] <- "Standing"
data.mean.std$activity[data.mean.std$activity == 6] <- "Laying"

colnames(data.mean.std)

###4. Appropriately labels the data set with descriptive variable names.
### Use Gsub to rename the variables

names(data.mean.std) <- gsub("Acc", "Acceleration", names(data.mean.std))
names(data.mean.std) <- gsub("^t", "Time", names(data.mean.std))
names(data.mean.std) <- gsub("^f", "Frequency", names(data.mean.std))
names(data.mean.std) <- gsub("BodyBody", "Body", names(data.mean.std))
names(data.mean.std) <- gsub("Freq", "Frequency", names(data.mean.std))
names(data.mean.std) <- gsub("Mag", "Magnitude", names(data.mean.std))


### From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidydata <- data.mean.std %>%
    group_by(subjectID, activity) %>%
    summarise_all(funs(mean))

### Save file 

write.table(tidydata, file = "tidydata.txt", sep = ";")
