library(dplyr)
library(tidyr)

# GETTING THE DATA

# Read the test set, together with the corresponding subject and
# activty labels. Do the same for the train set. 

df_subject_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", colClasses = "factor")
df_activity_test <- read.csv("UCI HAR Dataset/test/y_test.txt", colClasses = "factor")
df_main_test <- read.csv("UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE, strip.white=TRUE)

df_subject_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", colClasses = "factor")
df_activity_train <- read.csv("UCI HAR Dataset/train/y_train.txt", colClasses = "factor")
df_main_train <- read.csv("UCI HAR Dataset/train/X_train.txt", stringsAsFactors = FALSE, strip.white=TRUE)


# Import the dataframes with feature labels and activity names

df_features <- read.table("UCI HAR Dataset/features.txt", colClasses = c("character","character"))
names(df_features) <- c("position", "name")

df_activities <- read.table("UCI HAR Dataset/activity_labels.txt", colClasses = c("factor","factor"))
names(df_activities) <- c("code", "activity")

# The following is to maintain the given order of factor levels
activity_levels <- as.character(df_activities$activity)
df_activities$activity <- factor(df_activities$activity, levels = activity_levels)


# MERGE THE TRAIN AND TEST DATASETS (by the rows)

names(df_main_train) <- "X"
names(df_main_test) <- "X"
df_main_merged <- rbind(df_main_train, df_main_test)

names(df_subject_train) <- "subject"
names(df_subject_test) <- "subject"
df_subject_merged <- rbind(df_subject_train, df_subject_test)
df_subject_merged$subject <- factor(df_subject_merged$subject, levels = as.character(c(1:30)) )

names(df_activity_train) <- "activitycode"
names(df_activity_test) <- "activitycode"
df_activity_merged <- rbind(df_activity_train, df_activity_test)


# SELECT THE DESIRED FEATURES [with mean() and std()] FOR EACH MEASUREMENT

# To start with, we identify the desired features by filtering the feature dataframe 
# depending on whether the feature name contains or not mean() or std().
# Then, we separate the content of X in the merged dataframe into multiple columns, 
# and select only the relevant ones.

df_selected_features <- filter(df_features, grepl("mean\\(\\)|std\\(\\)", name))

df_main_merged <-  df_main_merged %>% 
  separate(X, as.character(c(1:561)), sep = "[ ]+") %>%
  select(one_of(df_selected_features$position))

# Now we convert the full main dataframe to numeric values, and give meaninful names
# to the features

df_main_merged <- as.data.frame(lapply(df_main_merged, as.numeric))
names(df_main_merged) <- df_selected_features$name



# MERGE THE MAIN DATAFRAME WITH SUBJECTS AND ACTIVITIES, CORRECTLY NAMED

df_merged <- cbind(df_subject_merged, df_activity_merged, df_main_merged)


# In order to add the name of the activity we first add a new column, 
# then we select the columns in the order we want (note that 3:68 are the
# columns with all the desired features).

df_merged <-  df_merged %>%
  merge(df_activities, by.x = "activitycode", by.y = "code") %>%
  select(subject, activity, 3:68)


# NOW WE MAKE THE DATA FRAME TIDY BY GATHERING THE DIFFERENT KIND OF MEASUREMENTS 

df_merged <- as.tbl(df_merged)
df_tidy <-  df_merged %>%
            gather(key = measurement, value = value, 3:68) %>%
            arrange(subject, activity)


# LAST REQUIRED TIDY DATA SET 

# We group the data by activity and subject, and then we take the average over all values
df_average <- df_tidy %>%
              group_by(subject, activity, measurement) %>%
              summarize(meanvalue = mean(value))


# Final data set is saved to a .csv file

write.table(df_average, file = "tidyset.txt", row.names = FALSE)