# Coursera---Getting-and-cleaning-data
This is the solution for the final project of the coursera.org course "Getting and cleaning data", of the data science specialization. 

The R script "run_analysis.R", that has to be placed in the same folder containing the input data set, available from
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip,
does the following:
1. Loads the train and test data sets (for subjects, activities, and measured features), as well the information on features and activities.
2. Merges (by rows) each train data set with the corresponding test data set.
3. Separates the merged dataset containing the list of feature measurements into multiple columns, select only the ones involving means or standard deviations, and gives them meaningful names taken from the feature list.
4. Merges (by columns) the dataframe obtained in this way with those containing the subject and activity for each observation.
5. Merges the obtained dataframe with the one containing the activity names, and removes the columns with the activity code (so that it effectively changes each activity code into the corresponding name).
5. Makes the dataframe tidy by gathering feature names and values into two columns.
6. Creates the final tidy dataset by grouping the dataframe obtained in the previous step by subject, activity and feature, and by taking the mean of the feature values.

The final tidy dataset is saved into the file "tidyset.txt". The file "codebook.md" gives information about the variables in the final dataset, as well as their relation to the original set of data.
