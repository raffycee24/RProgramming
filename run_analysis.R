library(dplyr)

# Check and download the file
file <- "Coursera_DS3_Final.zip"
if (!file.exists(file)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, file, method="curl")
} 
# unzip the file
if (!file.exists("UCI HAR Dataset")) { 
  unzip(file) 
}

# assign each data frame
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","Functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("Code", "Activity"))
subject_testset <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
x_testset <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$Functions)
y_testset <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "Code")
subject_trainset <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
x_trainset <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$Functions)
y_trainset <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "Code")

# Merges the training and the test sets to create one data set.
Xdata <- rbind(x_trainset, x_testset) # merge the training and testing set for x dataset
Ydata <- rbind(y_trainset, y_testset) # merge the training and testing set for y dataset
Subjects <- rbind(subject_trainset, subject_testset) #merge the training set and testing set
Merged <- cbind(Subjects, Ydata, Xdata)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
step2 <- Merged %>% select(Subject, Code, contains("mean"), contains("std"))

# Uses descriptive activity names to name the activities in the data set
step2$Code <- activities[step2$Code, 2]


# Appropriately labels the data set with descriptive variable names
names(step2)[2] = "activity"
names(step2)<-gsub("Acc", "Accelerometer", names(step2))
names(step2)<-gsub("Gyro", "Gyroscope", names(step2))
names(step2)<-gsub("BodyBody", "Body", names(step2))
names(step2)<-gsub("Mag", "Magnitude", names(step2))
names(step2)<-gsub("^t", "Time", names(step2))
names(step2)<-gsub("^f", "Frequency", names(step2))
names(step2)<-gsub("tBody", "TimeBody", names(step2))
names(step2)<-gsub("-mean()", "Mean", names(step2), ignore.case = TRUE)
names(step2)<-gsub("-std()", "STD", names(step2), ignore.case = TRUE)
names(step2)<-gsub("-freq()", "Frequency", names(step2), ignore.case = TRUE)
names(step2)<-gsub("angle", "Angle", names(step2))
names(step2)<-gsub("gravity", "Gravity", names(step2))


# From the data set in step 4, creates a second, independent tidy
# data set with the average of each variable for each activity and each subject
step5 <- step2 %>%
    group_by(Subject, activity) %>%
    summarise_all(funs(mean))
write.table(step5, "FinalData.txt", row.name=FALSE)
