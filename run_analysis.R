#This code assumes that the dataset is present in the same working directory as the code. The dataset
#also has the following structure:: UCI HAR Dataset being the main folder and the dataset being present
#inside the main folder. 


#Reading activity legend
activity_labels <- read.csv("UCI HAR Dataset/activity_labels.txt",sep=" ", header=FALSE)


#reading feature array (character array) for column names for test and training data
feature_labels <- read.csv("UCI HAR Dataset/features.txt",sep=" ", header=FALSE)
feature_labels_array <- feature_labels[1:561,2]
feature_array <- as.character(feature_labels_array)

#reading activity code for test data
activity_code_test <- read.csv("UCI HAR Dataset/test/y_test.txt", sep=" ",header = FALSE, col.names=c("Activity_ID"))
#converting activity code to labels

  for (i in 1:2947)
    {
    index <- activity_code_test[i,1]
    activity_code_test[i,1] <- as.character(activity_labels[index,2])
    }

#reading subject ID for test data 
subject_ID_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep=" ",header = FALSE, col.names=c("Subject_ID"))
#reading measurements for test data
data_test <- read.table("UCI HAR Dataset/test/x_test.txt", sep="",header = FALSE,col.names = feature_array)
#append subject ID to the data
data_test_tidy <- cbind(activity_code_test,data_test)
data_test_tidy <- cbind(subject_ID_test,data_test_tidy)

#reading activity code for train data
activity_code_train <- read.csv("UCI HAR Dataset/train/y_train.txt", sep=" ",header = FALSE, col.names=c("Activity_ID"))
#converting activity code to labels

for (i in 1:7352)
{
  index <- activity_code_train[i,1]
  activity_code_train[i,1] <- as.character(activity_labels[index,2])
}

#reading subject ID for train data 
subject_ID_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep=" ",header = FALSE, col.names=c("Subject_ID"))
#reading measurements for train data
data_train <- read.table("UCI HAR Dataset/train/X_train.txt", sep="",header = FALSE,col.names = feature_array)
#append subject ID to the data
data_train_tidy <- cbind(activity_code_train,data_train)
data_train_tidy <- cbind(subject_ID_train,data_train_tidy)

combined_tidy_data <- rbind(data_train_tidy,data_test_tidy)

#extracting short_feature_array with only means and standard deviation
short_feature_array <- c(1:8, 43:48, 123:128)
meanstd_tidy_dataset <- select(combined_tidy_data,short_feature_array)



## this Part of the code performs mean calculation of meanstd_tidy_dataset for each subject and each activity
temp <- select(meanstd_tidy_dataset,-(1:2))
by1 <- combined_tidy_data$Subject_ID
by2 <- combined_tidy_data$Activity
ans <- aggregate.data.frame(temp,FUN=mean,by=list(by1,by2))
orig_colnames <- colnames(ans) 
orig_colnames[1] <- "Subject_ID"
orig_colnames[2] <- "Activity_ID"
colnames(ans) <- orig_colnames
write.table(ans, file="Output.txt", row.names = FALSE)