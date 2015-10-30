# Running the script 'create_data_set.R' which creates the table on which the
# analysis will be performed.
source("create_data_set.R")

# From the data set X_slct, create a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
library(dplyr)
grpd_avrg <- X_slct %>% group_by(activity, subject) %>% summarize_each(funs(mean))
write.table(grpd_avrg,file="averages_data.txt",row.names = FALSE)

