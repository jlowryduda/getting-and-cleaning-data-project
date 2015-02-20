library(plyr)
library(dplyr)


#-------------Read in, label and combine the test set, test set activity data, test set subject data----
test_set <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_activity <- read.table("./UCI HAR Dataset/test/y_test.txt")
colnames(test_activity) <- "activity"
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(test_subject) <- "subject"
test_set <- cbind(test_subject, test_activity, test_set)


#-------------Read in, label and combine the train set, train set activity data, train set subject data-
train_set <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_activity <- read.table("./UCI HAR Dataset/train/y_train.txt")
colnames(train_activity) <- "activity"
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(train_subject) <- "subject"
train_set <- cbind(train_subject, train_activity, train_set)


#-------------Merge the training and the test sets to create one data set-------------------------------
data_set <- rbind(train_set, test_set)


#-------------Use descriptive activity names to name the activities in the data set---------------------
activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_hash <- as.vector(tolower(activity_names$V2))
names(activity_hash) <- activity_names$V1
data_set <- mutate(data_set, "activity"=activity_hash[data_set$activity])


#-------------Label data with descriptive variable names------------------------------------------------
variables <- read.table("./UCI HAR Dataset/features.txt")
filtered <- filter(variables, grepl("-mean()", V2, fixed = TRUE) | grepl("-std()", V2, fixed = TRUE))
features_hash <- as.vector(filtered$V2)
names(features_hash) <- unlist(lapply(filtered$V1, function(x) paste("V", x, sep="")))
data_set <- plyr:::rename(data_set, features_hash)


#-------------Extract only the measurements on the mean and std for each measurement--------------------
data_set <- select(data_set, -starts_with("V"))


#-------------Write a tidy data set to a file-----------------------------------------------------------
write.table(data_set, file = "./UCI HAR Dataset/tidy_data.txt", row.names = FALSE)


#-------------Create a tidy data set with a mean of each variable for each activity and each subject----
subject_activity_groups <- group_by(data_set, subject, activity)
mean_by_subject_activity <- summarise_each(subject_activity_groups, funs(mean))


#-------------Write a data set containing means of variables for each activity and subject to a file----
write.table(mean_by_subject_activity, file = "./UCI HAR Dataset/mean_by_subject_activity.txt")