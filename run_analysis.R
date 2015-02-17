# Script to create a tidy dataset with average of means and standard deviations of all 
# variables in the original data set.

# download zip file. Unzipped to a new folder named "project" in 
# working directory. 
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./project.zip")
unzip("./project.zip",exdir="./project")
setwd("./project/UCI HAR Dataset")
# Load data.table package for faster and more efficient reading.
library("data.table")
# Load dplyr package for easier data frame manipulation.
library("dplyr")

# Load all tables
activity_label <- data.table(read.table("activity_labels.txt", stringsAsFactors=FALSE))
test <- data.table(read.table("./test/X_test.txt", stringsAsFactors=FALSE))
train <- data.table(read.table("./train/X_train.txt", stringsAsFactors=FALSE))
test_label <- data.table(read.table("./test/y_test.txt", stringsAsFactors=FALSE))
subj_lab_test <- data.table(read.table("./test/subject_test.txt", stringsAsFactors=FALSE))
train_label <- data.table(read.table("./train/y_train.txt", stringsAsFactors=FALSE))
subj_lab_train <- data.table(read.table("./train/subject_train.txt", stringsAsFactors=FALSE))
features <- read.table("features.txt")

#Create new columns for activity number and Subject number for test dataset.
test <- test[,Act:=test_label$V1]
test <- test[,Subject:=subj_lab_test$V1]
setnames(activity_label,"V1","Act") #change names in activity_label to provide
#key for merging in the next line. Activity name is now used to label each 
#observation.
test <- merge(test,activity_label,by="Act")
setnames(test,"V2.y","Activity")
test <- select(test,2:564)

#Similar for training set.
train <- train[,Act:=train_label$V1]
train <- train[,Subject:=subj_lab_train$V1]
train <- merge(train,activity_label,by="Act")
setnames(train,"V2.y","Activity")
train <- select(train,2:564)
setnames(train,"V2.y","Activity")

#Merge training and test datasets. Variables are labelled with descriptive 
#names as originally provided in the features.txt file.
dat <- rbindlist(list(test,train))
setnames(dat,colnames(dat)[1:561],as.character(features$V2))

#Select for variables on mean and standard deviation. All related to meanFreq
#(which will be selected via this method) are fi
features_mf <- grep("meanFreq",features$V2)
feat <- features$V1
feat <- feat[-features_mf] #All related to meanFreq which will be selected 
#below with grep("mean") mistakenly) are filtered out.
features_mu <- grep("mean",features$V2)
features_sd <- grep("std",features$V2)
features <- c(features_mu,features_sd)
features <- intersect(feat,features)
features <- c(features,562,563) #Add back the Activity and Subject columns.
dat <- select(dat,features)

#Group by Subject and Activity, summarise each remaining columns with their
#averages. All columns are named "Average_(original name)" as indication.
dat2 <- group_by(dat,Subject,Activity,add=FALSE)
dat3 <- summarise_each(dat2, funs(mean))
dat3col <- sapply(colnames(dat3)[3:68],function(j) paste("Average",j,sep="_"))
setnames(dat3,colnames(dat3)[3:68],dat3col)

#Tidy data set (dat3) completed. Export dat3 to "final_data.txt" in the 
#working directory.
write.table(dat3,"./final_data.txt",row.names=FALSE)

#tidy data set is to be read by read.table("final_data.txt",header=TRUE).
