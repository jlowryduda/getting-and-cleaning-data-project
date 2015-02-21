# Getting and cleaning data - course project (Coursera)

The repo contains the following files:
* run_analysis.R, which creates a tidy data set from UCI HAR dataset.
* README.md, which explains the process in run_analysis.R
* codebook.md, which contains descriptions of the data, the variables used, as well as their units.

R script run_analysis.R manipulates UCI HAR Dataset. The dataset is available here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip (accessed February 2015). The code assumes that the dataset directory is located within the working directory. 

The script executes the following steps:

1. Reads in, labels and combines into one data frame the following data:
  * the test set
  * test set activity data
  * test set subject data

  The test set is the content of X_test.txt which consist of 561-feature vectors, each representing a 2.56 s time window. Test set activity data is the content of y_test.txt, and consist of a label of activity that was performed during each time window. Test subject data is the content of subject_test.txt, and consists of a label of a subject which performed an activity suring a given time window.
  
  ```R
test_set <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_activity <- read.table("./UCI HAR Dataset/test/y_test.txt")
colnames(test_activity) <- "activity"
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(test_subject) <- "subject"
test_set <- cbind(test_subject, test_activity, test_set)
```

2. Reads in, labels and combines into one data frame the following data:
  * the train set
  * train set activity data
  * train set subject data

  The train set is the content of X_train.txt which consist of 561-feature vectors, each representing a 2.56 s time window. Test set activity data is the content of y_train.txt, and consist of a label of activity that was performed during each time window. Test subject data is the content of subject_train.txt, and consists of a label of a subject which performed an activity suring a given time window.
  
  ```R
train_set <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_activity <- read.table("./UCI HAR Dataset/train/y_train.txt")
colnames(train_activity) <- "activity"
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(train_subject) <- "subject"
train_set <- cbind(train_subject, train_activity, train_set)
  ```
  
3. Merges the training and the test sets to create one data set. Merging is achieved using rbind command.

    ```R
  data_set <- rbind(train_set, test_set)
  ```
4. Substitutes activity labels for descriptive activity names.
  
    ```R
activity_names <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_hash <- as.vector(tolower(activity_names$V2))
names(activity_hash) <- activity_names$V1
data_set <- mutate(data_set, "activity"=activity_hash[data_set$activity])
  ```
  Original data uses integers (1, 2, 3, 4, 5, 6) to label activities. The code reads in a file containing a mapping from an integer to an activity. Then, it creates a hash table (implemented as a named list) where keys are integers and activities are the values. The code uses mutate dplyr function to substitute integers to meaningful names.
  
5. Labels data with descriptive variable names.

  ```R
variables <- read.table("./UCI HAR Dataset/features.txt")
filtered <- filter(variables, grepl("-mean()", V2, fixed = TRUE) | grepl("-std()", V2, fixed = TRUE))
features_hash <- as.vector(filtered$V2)
names(features_hash) <- unlist(lapply(filtered$V1, function(x) paste("V", x, sep="")))
data_set <- plyr:::rename(data_set, features_hash)
  ```
  
  When the original data is loaded into R, the variables are assigned a default names, such as V1, V2, etc. The code reads in features.txt and then extracts only the features that contain -mean() or -std() in their names together with their indices. Index-feature pairs are then turned into a hash table (implemented as a named list). Then, plyr's rename function is used to rename variables with appropriate indices to descriptive names. Please note that the measurements that were labeled with a label that did not contain -mean() or -std() will at this point still be labeled with default names starting with "V".
  
6. Extracts only the measurements on the mean and strandard deviation.

  ```R
  data_set <- select(data_set, -starts_with("V"))
  ```
  
  At this point, the variables that were not renamed in step 5 (i.e. ones that do not refer to mean or standard deviation) are filtered out from the data set.
  
7. Creates a tidy data set with a mean of each variable for each activity for each subject.

  ```R
subject_activity_groups <- group_by(data_set, subject, activity)
mean_by_subject_activity <- summarise_each(subject_activity_groups, funs(mean))
  ```
  
  The data is first grouped by subject and activity. Then, mean is applied to each group using summarise_each dplyr's function.
  
8. Writes the clean data sets to a file.

  ```R
  write.table(data_set, file = "./UCI HAR Dataset/tidy_data.txt", row.names = FALSE)
  write.table(mean_by_subject_activity, file = "./UCI HAR Dataset/mean_by_subject_activity.txt")
  ```
