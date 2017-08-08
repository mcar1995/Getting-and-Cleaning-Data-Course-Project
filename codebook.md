Data source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Data description : http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


FILES
features.txt: Names of the 561 features.

activity_labels.txt: Names and IDs for each of the 6 activities.

X_train.txt: 7352 observations of the 561 features, for 21 of the 30 volunteers.

subject_train.txt: A vector of 7352 integers, denoting the ID of the volunteer related to each of the observations in X_train.txt.

y_train.txt: A vector of 7352 integers, denoting the ID of the activity related to each of the observations in X_train.txt.

X_test.txt: 2947 observations of the 561 features, for 9 of the 30 volunteers.

subject_test.txt: A vector of 2947 integers, denoting the ID of the volunteer related to each of the observations in X_test.txt.

y_test.txt: A vector of 2947 integers, denoting the ID of the activity related to each of the observations in X_test.txt.

VARIABLES

path <- File path to the UCI HAR Dataset files

train_subject <- subjectID of train files
train_activity <- activity data of train files
train_featureset <- feature set data of train files

test_subject <- subject ID of test files
test_activity <- activity data of test files
test_featureset <- feature set fata of train files

data_measurements <- extracted measurements of only mean and standard deviation
