# Getting and cleaning data - course project (Coursera)

run_analysis.R contains R code that manipulates UCI HAR Dataset. The dataset is available here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip (accessed February 2015).The code assumes that the dataset directory is located within the working directory.

The script executes the following steps:
1. Reads in, labels and combines into one data frame the following data:
*the test set
*test set activity data
*test set subject data

The test set is the content of X_test.txt which consist of 561-feature vectors, each representing a 2.56 s time window. Test set activity data is the content of y_test.txt, and consist of a label of activity that was performed during each time window. Test subject data is the content of subject_test.txt, and consists of a label of a subject which performed an activity suring a given time window.
