## Load Packages

```{r}
library(dplyr)
```


## Downloading and Attaching Dataset

```{r, message=FALSE}
# Check and download the file
file <- "Coursera_DS3_Final.zip"
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
} 
# unzip the file
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
```


## Assigning of Data Frame

```{r}
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","Functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("Code", "Activity"))
subject_testset <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
x_testset <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$Functions)
y_testset <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "Code")
subject_trainset <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
x_trainset <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$Functions)
y_trainset <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "Code")
```


## Merging Data Set

```{r}
Xdata <- rbind(x_trainset, x_testset) # merge the training and testing set for x dataset
Ydata <- rbind(y_trainset, y_testset) # merge the training and testing set for y dataset
Subjects <- rbind(subject_trainset, subject_testset) #merge the training set and testing set
Merged <- cbind(Subjects, Ydata, Xdata)
```


## Extracting Measurements

```{r}
step2 <- Merged %>% select(Subject, Code, contains("mean"), contains("std"))
```


## Using descriptive activity

```{r}
step2$Code <- activities[step2$Code, 2]
```


## Labeling the Dataset

```{r}
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
```

## Tidy Dataset

```{r}
step5 <- step2 %>%
    group_by(Subject, activity) %>%
    summarise_all(funs(mean))
write.table(step5, "FinalData.txt", row.name=FALSE)
```
