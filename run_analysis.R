##Coursera: "Getting and Cleaning Data" course project
# Hao Zhang @ 2015.11.10
#create a function to include or install required packages
include <- function(pkg) {
    for (pk in pkg){
        if(!(pk %in% installed.packages())) {
            install.packages(pk)
        }
        library(pk,character.only = T)
    }
}
#load dplyr and reshape2 packages
include(c("dplyr","reshape2"))

##download the zip file if it hasn't been downloaded
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("project.zip")){
    download.file(URL,"project.zip")    #windows doesn't like method='curl'
}
##unzip file if it hasn't been unziped
if (!dir.exists("project")){
    #flatten the dir tree for easier accessibility
    unzip("project.zip",exdir = "project/", junkpaths = T)
}

# 1. Merges the training and the test sets to create one data set.
X_train <- read.table(file = "project/X_train.txt",header = F)
X_test <- read.table(file = "project/X_test.txt",header = F)
# X is the data set of test + train
X <- rbind(X_test,X_train)
# add colnames from features.txt
feature <- read.table(file="project/features.txt",header=F,stringsAsFactors = F)
colnames(X) <- feature[,2]

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
sub <- subset(X,select=grepl("mean|std",names(X)))

# 3. Uses descriptive activity names to name the activities in the data set
y_test <- read.table(file="project/y_test.txt",header = F)
y_train <- read.table(file="project/y_train.txt",header = F)
# y is the activity index of test + train
y  <- rbind(y_test,y_train)

# act is the activities from activitity_labels.txt
act <- read.table("project/activity_labels.txt",header = F,col.names = c("activity","activity_name"))
#left join the activity index and the descriptive activities name
y_act <- merge(x=y,y=act,by.x=1,by.y="activity", all.x=TRUE)
# xy is the tidy data that includes data and descriptive activities for test + train
xy <- cbind(sub,y_act[2])
write.table(xy,"xy.txt",row.names = F)
# 4. Appropriately labels the data set with descriptive variable names.
#done in step 1

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
sub_test <- read.table("project/subject_test.txt",header = F)
sub_train <- read.table("project/subject_train.txt", header=F)
# sub is the subjects of test + train
sub <- rbind(sub_test,sub_train)
colnames(sub) <- "subject"
# xy_sub is the combined data frame of xy + subject
xy_sub <- cbind(xy,sub)
#agg <- lapply(xy_sub,function(x){tapply(x,xy_sub[,81:80], mean)})

# agg is the summarized data set that has the averaged values
agg <- aggregate(xy_sub[,1:79],by=list(xy_sub$subject,xy_sub$activity_name),mean)
#rename the first two columns
agg <- rename(agg,Subject=Group.1,Activity=Group.2)
write.table(agg,"agg.txt",row.names = F)
#clean up
rm(list=setdiff(ls(),c("xy","agg")))
