##Coursera: "Getting and Cleaning Data" course project
# Hao Zhang @ 2015.11.10
#create a function to include or install required packages
req_pkg <- function(pkg) {
    for (pk in pkg){
        if(!(pk %in% installed.packages())) {
            install.packages(pk)
        }
        library(pk,character.only = T)
    }
}
#load dplyr and reshape2 packages
req_pkg(c("dplyr","reshape2"))

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
#regex '\\(' matches '('
sub <- subset(X,select=grepl("mean\\(\\)|std\\(\\)",names(X)))

# 3. Uses descriptive activity names to name the activities in the data set
y_test <- read.table(file="project/y_test.txt",header = F)
y_train <- read.table(file="project/y_train.txt",header = F)
# y is the activity index of test + train
y  <- rbind(y_test,y_train)

# act is the activities from activitity_labels.txt
act <- read.table("project/activity_labels.txt",header = F,col.names = c("activity","activity_name"))
#left join the activity index and the descriptive activities name

#### this is where it goes wrong:
#### merge() automatically sorts columns, even with sort=F it's still making trouble
#### it seems work fine if the 'by' columns are the same, otherwise, it's sort in 'unspecified order'
#y_act2<- merge(x=y,y=act,by.x="V1",by.y="activity", all.x=TRUE,sort = F)

#alternative method: left_join() is part of dplyr package, and it doesn't sort data
y_act <- left_join(y,act,by=c("V1"="activity"))
# xy is the tidy data that includes data and descriptive activities for test + train
xy <- cbind(sub,y_act[2])
write.table(xy,"xy.txt",row.names = F)
# 4. Appropriately labels the data set with descriptive variable names.
#done in step 1

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
sub_test <- read.table("project/subject_test.txt",header = F)
sub_train <- read.table("project/subject_train.txt", header=F)
# sub is the subjects of test + train
subj <- rbind(sub_test,sub_train)
colnames(subj) <- "subject"
# xy_sub is the combined data frame of xy + subject
xy_sub <- cbind(xy,subj)
# agg is the summarized data set that has the averaged values
agg <- aggregate(xy_sub[,1:(ncol(xy_sub)-2)],by=list(xy_sub$subject,xy_sub$activity_name),mean)
#rename the first two columns
agg <- rename(agg,Subject=Group.1,Activity=Group.2)
#alternative method: I think this way is more clear
#agg <- xy_sub %>% group_by(activity_name, subject) %>% summarize_each(funs(mean))
write.table(agg,"agg.txt",row.names = F)
#clean up
rm(list=setdiff(ls(),c("xy","agg")))
