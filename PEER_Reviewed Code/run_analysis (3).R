
######Assuming that all the txt files exist in working directory
###load the dplyr package
library(dplyr)
####Read the tct files
activity_labels<-read.csv("activity_labels.txt", sep="", header=FALSE)
features<-read.csv("features.txt", sep="", header=FALSE)
subject_test<-read.csv("subject_test.txt", sep="", header=FALSE)
subject_train<-read.csv("subject_train.txt", sep="", header=FALSE)
X_test<-read.csv("X_test.txt", sep="", header=FALSE)
X_train<-read.csv("X_train.txt", sep="", header=FALSE)
Y_train<-read.csv("Y_train.txt", sep="", header=FALSE)
Y_test<-read.csv("Y_test.txt", sep="", header=FALSE)




###create the test set

colnames(X_test)<-as.vector(features$V2)
TestTrain<-rep("Test", length(X_test[,1]))
colnames(subject_test)<-"PersonID"
Y_testID<-cbind(Y_test, row.names(Y_test))
colnames(Y_testID)<-c("ActivityID", "rowid")
names(activity_labels)<-c("ActivityID", "ActivityLabels")
###merge the userbases
Test_Activities<-merge(Y_testID, activity_labels)
###order by row number
Test_Activities<-arrange(Test_Activities, as.numeric(as.vector(rowid)))
Test_df<-cbind(Test_Activities, subject_test, TestTrain, X_test)



####create the train set applying the same process with the test set
colnames(X_train)<-as.vector(features$V2)
TestTrain<-rep("Train", length(X_train[,1]))
colnames(subject_train)<-"PersonID"
Y_trainID<-cbind(Y_train, row.names(Y_train))
colnames(Y_trainID)<-c("ActivityID", "rowid")
Train_Activities<-merge(Y_trainID, activity_labels)
Train_Activities<-arrange(Train_Activities, as.numeric(as.vector(rowid)))
Train_df<-cbind(Train_Activities, subject_train, TestTrain, X_train)

###create the train and test set 

my_df<-rbind(Test_df, Train_df)

###removing the multiple columns
my_df_unique <- my_df[ !duplicated(names(my_df)) ]

###select the columns which contain the mean and the std for every subject and activity
my_df_mean_and_sd <- select(my_df_unique, PersonID, ActivityLabels, contains("mean()"), contains("std"))


####get the means for all columns for the groups PersondID and ActiviryLables
means_PersonID_Activity<-my_df_mean_and_sd %>%group_by(PersonID, ActivityLabels)%>%summarise_each(funs(mean))
means_PersonID_Activity


