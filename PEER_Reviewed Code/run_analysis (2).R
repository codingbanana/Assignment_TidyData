getwd()
setwd("C:/Users/Public/Documents")
dir.create("course_project")
setwd("C:/Users/Public/Documents/course_project")

#download files from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#and put folder "UCI HAR Dataset" un your working directory
#check that all neede files are in place
list.files("./UCI HAR Dataset/test")
list.files("./UCI HAR Dataset/train")
list.files("./UCI HAR Dataset")

#q1 Merges the training and the test sets to create one data set.

#upload activity labels and activity descr in R
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
#upload 561-dim vector with variables names in R
variable_names <-read.table("./UCI HAR Dataset/features.txt")

#upload and prepare train data into R
#upload main train data into R
x_train_data<-read.table("./UCI HAR Dataset/train/x_train.txt")
#assign variable names from features.txt file
colnames(x_train_data) <-c(t(variable_names[-c(1)]))
#upload subjects which performed experiment, this will be our future "subjID" viriable
subject_train<- read.table("./UCI HAR Dataset/train/subject_train.txt")
#assign temporary column name to operate
colnames(subject_train) <-c("subj")
#upload activity codes for each row from y_train.txt
activity_code_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
#assign temporary column name to operate
colnames(activity_code_train) <-c("act_c_tr")


#upload and prepare test data into R and Appropriately labels the data set with descriptive variable names
#upload main test data into R
x_test_data<-read.table("./UCI HAR Dataset/test/X_test.txt")
#assign variable names from features.txt file
colnames(x_test_data) <-c(t(variable_names[-c(1)]))
#upload subjects which performed experiment, this will be our future "subjID" viriable
subject_test<- read.table("./UCI HAR Dataset/test/subject_test.txt")
#assign temporary column name to operate
colnames(subject_test) <-c("subj")
#upload activity codes for each row from y_test.txt
activity_code_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
#assign temporary column name to operate
colnames(activity_code_test) <-c("act_c_tr")


#combine data
#combine data for train set subjects+activity codes+all other measures
full_x_train_data <- cbind(subject_train,activity_code_train,x_train_data)
#combine data for test set subjects+activity codes+all other measures
full_x_test_data <- cbind(subject_test,activity_code_test,x_test_data)
#combine data from test set and train set
q1_final_data<- rbind(full_x_train_data, full_x_test_data)

#q2 Extracting only the measurements on the mean and standard deviation for each measurement.
#extract variable names to filter
q2_var_names <- names(q1_final_data)
#get indexes of neccessary variables
q2_var_names<-grep("mean|std",q2_var_names)
#print them
q2_var_names

#get all variables aacroding to our filter
q2_data <- q1_full_data[q2_var_names]
#store variable names inq2_data_names
q2_data_names <-names(q2_data)
#get indexes of varibles to exclude
q2_data_names<-grep("meanFreq",q2_data_names)
#print them
q2_data_names
#exclude varibles wirth meanFreq and get final data set
q2_final_data<-q2_data[-c(q2_data_names)]

#q3/4 Using descriptive activity names to name the activities in the data set and
#Appropriately labels the data set with descriptive variable names
# add subjects and activity index
q3_data <- cbind(q1_full_data$subj,q1_full_data$act_c_tr,q2_final_data)
#rename first 2 columns
colnames(q3_data)[1:2]<-c("subj","act_code")
##rename columns in activity_labels
colnames(activity_labels)[1:2] <- c("act_code","act_name")
#merge data by act_cod
q3_final_data <- merge(q3_data,activity_labels, by = 'act_code')
q4_final_data <- q3_final_data #it's just foravoid misunderstanding
#get final data
write.table(q4_final_data, "./course_project/q4_data.txt", sep="\t", row.names = FALSE)

#q5 From the q4_final_data, create independent tidy data set with the average of each variable for each activity and each subject.
tidy_data<-aggregate(q4_final_data,by=list(activity=q4_final_data$act_name,subjID=q4_final_data$subj),FUN = mean)
# delete excessive columns
tidy_data<-tidy_data[-c(4,71)]
#export tidy_data
write.table(tidy_data, "./course_project/tidy_data.txt", sep="\t", row.names = FALSE)
