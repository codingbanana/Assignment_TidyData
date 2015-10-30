# Reading all the files I am going to merge together
# The files are located in the working directory
X_test <- read.table("X_test.txt",stringsAsFactors = FALSE)
X_train <- read.table("X_train.txt",stringsAsFactors = FALSE)
y_test <- read.table("y_test.txt",stringsAsFactors = FALSE)
y_train <- read.table("y_train.txt",stringsAsFactors = FALSE)
subject_test <- read.table("subject_test.txt",stringsAsFactors = FALSE)
subject_train <- read.table("subject_train.txt",stringsAsFactors = FALSE)

# Adding the columns with activity and person lables for test and train respectively
X_test_all <- cbind(X_test,y_test,subject_test)
X_train_all <- cbind(X_train,y_train,subject_train)

# Merging the train and the test dataset in one dataset
X_all <- rbind(X_train_all,X_test_all)

# Reading the features and converting them into a character vector
ftrs <- read.table("features.txt",stringsAsFactors = FALSE)
ftrs_vec <- as.character(ftrs$V2)

# Extracting indexes of variables containing mean() and std() respctively
i_mean <- grep("mean\\(\\)", ftrs_vec)
i_std <- grep("std\\(\\)", ftrs_vec)
i <- sort(c(i_mean,i_std))
# Merging the indexes in one vector and then order the indexes in increasing order
ii <- c(i,ncol(X_all)-1,ncol(X_all))

# Extracts only the measurements on the mean and standard deviation for each measurement. 
X_slct <- X_all[,ii]

# Reading the activities
actvts <- read.table("activity_labels.txt",stringsAsFactors = FALSE)

# Uses descriptive activity names to name the activities in the data set
for (j in 1:nrow(X_slct)){
  k <- X_slct[j,ncol(X_slct)-1]
  X_slct[j,ncol(X_slct)-1] <- actvts[k,2]
}

# Appropriately labels the data set with descriptive variable names:
# Generate a vector with the selected features from features.txt
ftrs_slct <- ftrs[i,2]
# Add at the end of such a vector the two labels for activity and subject
# In such a way we build the vector which will be used to create a header
header_vec <- c(ftrs_slct,"activity","subject")
names(X_slct) <- header_vec
