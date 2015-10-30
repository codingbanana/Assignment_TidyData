<<<<<<< HEAD
##Coursera: "Getting and Cleaning Data" course project
# Hao Zhang @ 2015.10.13

##download the zip file if it hasn't been downloaded
if (!file.exists("project.zip")){
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","project.zip",method = "curl")
}
##unzip file if it hasn't been unziped
if (!dir.exists("project")){
    #flatten the dir tree for easier accessibility
    unzip("project.zip",exdir = "project/", junkpaths = T)
}

# 1. Merges the training and the test sets to create one data set.
X_train <- read.table(file = "project/X_train.txt",header = F)
X_test <- read.table(file = "project/X_test.txt",header = F)
X <- rbind(X_test,X_train)
rm("X_test","X_train")
# add colnames
feature <- read.table(file="project/features.txt",header=F,stringsAsFactors = F)
feature <- feature[,2]
colnames(X) <- feature
# # assign variables, inialize values
# axial1 <- c("x","y","z")
# axial2  <- c("X","y")
# acc_type <- c("body","total")
# mes_type <- c("acc","gyro")
# dat_type <- c("train","test")
#
# #read activity and features
# act <- read.table("project/activity_labels.txt",header = F)
# feat <- read.table("project/features.txt",header = F)
#
# #read data tables, assign them to same-name objects
# for(i in 1:length(dat_type)) {
#     assign(paste("subject_",dat_type[i],sep=""), read.table(paste("project/subject_",dat_type[i], ".txt",sep=""), header=F))
#     for (m in 1:length(axial2)) {
#         assign(paste(axial2[m],"_",dat_type[i],sep=""), read.table(paste("project/",axial2[m], "_",dat_type[i], ".txt",sep=""), header=F))
#     }
#     for (n in 1:length(axial1)){
#         for(j in 1:length(mes_type)) {
#             for(k in 1:length(acc_type)) {
#                 if (j==2) {k=1}
#                 assign(paste(acc_type[k],"_",mes_type[j],"_",axial1[n],"_",dat_type[i],sep=""), read.table(paste("project/",acc_type[k],"_",mes_type[j],"_",axial1[n],"_",dat_type[i],".txt",sep=""), header=F))
#             }
#         }
#     }
# }


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
sub <- subset(X,select=grepl("mean",names(X)))
sub2 <- subset(X,select=grepl("std",names(X)))
sub <- cbind(sub,sub2)
rm("sub2")
# 3. Uses descriptive activity names to name the activities in the data set
y_test <- read.table(file="project/y_test.txt",header = F)
y_train <- read.table(file="project/y_train.txt",header = F)
y  <- rbind(y_test,y_train)
rm("y_test","y_train")
act <- read.table("project/activity_labels.txt",header = F,col.names = c("activity","activity_name"))
y_act <- merge(x=y,y=act,by.x=1,by.y=1, all.x=TRUE)
xy <- cbind(sub,y_act[2])
rm(y_act)
# 4. Appropriately labels the data set with descriptive variable names.
xy_col <- colnames(xy)
#replace colnames with descriptive variable names
temp <- gsub("Acc","Acceleration", xy_col)
temp <- gsub("gyro","AngularVelocity", temp)
temp <-gsub("Mag","Magnitude", temp)
temp <-gsub("-mean()","Mean",temp)
temp <-gsub("-std()","StandardDeviation",temp)
temp <-gsub("-X","Xaxis",temp)
temp <-gsub("-Y","Yaxis",temp)
temp <-gsub("-Z","Zaxis",temp)
for (i in 1:length(temp)) {
    if (substr(temp[i],1,1)=="t") {
        temp[i] <- paste("time",substring(temp[i],2),sep = "")
    }
    if (substr(temp[i],1,1)=="f") {
        temp[i] <- paste("frequency",substring(temp[i],2),sep="")
    }
}
#reassign colnames
colnames(xy) <- temp
rm(xy_col,i,feature,temp)
rm(act,sub,X,y)
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
sub_test <- read.table("project/subject_test.txt",header = F)
sub_train <- read.table("project/subject_train.txt", header=F)
sub <- rbind(sub_test,sub_train)
colnames(sub) <- "subject"
xy_sub <- cbind(xy,sub)
avg_df <- ddply(.data = xy_sub,.variables = c("activity_name","subject"),.fun = "mean")
#just a test
=======
##Coursera: "Getting and Cleaning Data" course project
# Hao Zhang @ 2015.10.13
#create a function to include or install required packages
req_pkg <- function(pkg){
    if(pkg %in% installed.packages()){
        library(pkg, character.only=TRUE)
    }else{
        install.packages(pkg)
    }
}
#load dplyr and reshape2 packages
req_pkg("dplyr")
req_pkg("reshape2")

##download the zip file if it hasn't been downloaded
if (!file.exists("project.zip")){
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","project.zip",method = "curl")
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
feature <- feature[,2]
colnames(X) <- feature

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
sub <- subset(X,select=grepl("mean",names(X)))
sub2 <- subset(X,select=grepl("std",names(X)))
#combines the two data frames
sub <- cbind(sub,sub2)

# 3. Uses descriptive activity names to name the activities in the data set
y_test <- read.table(file="project/y_test.txt",header = F)
y_train <- read.table(file="project/y_train.txt",header = F)
# y is the activity index of test + train
y  <- rbind(y_test,y_train)

# act is the activities from activitity_labels.txt
act <- read.table("project/activity_labels.txt",header = F,col.names = c("activity","activity_name"))
#left join the activity index and the descriptive activities name
y_act <- merge(x=y,y=act,by.x=1,by.y=1, all.x=TRUE)
# xy is the tidy data that includes data and descriptive activities for test + train
xy <- cbind(sub,y_act[2])
write.table(xy,"xy.txt",row.names = F)
# 4. Appropriately labels the data set with descriptive variable names.
xy_col <- colnames(xy)
#replace colnames with descriptive variable names
temp <- gsub("Acc","Acceleration", xy_col)
temp <- gsub("gyro","AngularVelocity", temp)
temp <-gsub("Mag","Magnitude", temp)
temp <-gsub("-mean()","Mean",temp)
temp <-gsub("-std()","StandardDeviation",temp)
temp <-gsub("-X","Xaxis",temp)
temp <-gsub("-Y","Yaxis",temp)
temp <-gsub("-Z","Zaxis",temp)
# replace the first character from either t or f to 'time' or 'frequency'
for (i in 1:length(temp)) {
    if (substr(temp[i],1,1)=="t") {
        temp[i] <- paste("time",substring(temp[i],2),sep = "")
    }
    if (substr(temp[i],1,1)=="f") {
        temp[i] <- paste("frequency",substring(temp[i],2),sep="")
    }
}
# reassign colnames to xy (tidy data)
colnames(xy) <- temp

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
sub_test <- read.table("project/subject_test.txt",header = F)
sub_train <- read.table("project/subject_train.txt", header=F)
# sub is the subjects of test + train
sub <- rbind(sub_test,sub_train)
colnames(sub) <- "subject"
# xy_sub is the combined data frame of xy + subject
xy_sub <- cbind(xy,sub)
# agg is the summarized data set that has the averaged values
agg <- aggregate(xy_sub[,1:79],by=list(xy_sub$subject,xy_sub$activity_name),mean)
#rename the first two columns
agg <- rename(agg,Subject=Group.1,Activity=Group.2)
write.table(agg,"agg.txt",row.names = F)
#clean up
rm(list=setdiff(ls(),c("xy","agg")))
>>>>>>> 2935042931422fc0f533478eff7b47cd39753447
