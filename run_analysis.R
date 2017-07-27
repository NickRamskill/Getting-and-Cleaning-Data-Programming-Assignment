## Getting and Cleaining Data - Programming Assignment 

# Set working directory to UCI HAR Dataset

# Read the activity labels tested
activityLabels <- read.table("activity_labels.txt")[,2]

# Read the features calculated - extract the ones associated with mean or standard deviation
features <- read.table("features.txt")
ind <- grep("mean|std",features[,2])

# Read Subject information
subjectTest <- read.table("test/subject_test.txt")
names(subjectTest) <- "Subject"

# Read Activity information
Ytest <- read.table("test/y_test.txt")
names(Ytest) <- "Activity"

# Read Test data and subset corresponding to mean/standard deviation
Xtest <- read.table("test/X_test.txt")
XTestSum <- Xtest[ind]
names(XTestSum) <- features[ind,2]

# Bind Subject, Activity and Test data information
Test <- cbind(subjectTest,Ytest,XTestSum)

subjectTrain <- read.table("train/subject_train.txt")
names(subjectTrain) <- "Subject"

Ytrain <- read.table("train/y_train.txt")
names(Ytrain) <- "Activity"

Xtrain <- read.table("train/X_train.txt")
XTrainSum <- Xtrain[ind]
names(XTrainSum) <- features[ind,2]

Train <- cbind(subjectTrain,Ytrain,XTrainSum)

# Combine Test and Train Data
dataSum <- rbind(Test,Train)

# Give descriptive labels to Activity labels
dataSum$Activity <- factor(dataSum$Activity,labels=c("Walking",
                                                     "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))

# Tidy variable names to make more readable
names(dataSum) <- gsub("^t", "Time", names(dataSum))
names(dataSum) <- gsub("^f", "Frequency", names(dataSum))
names(dataSum) <- gsub("-mean\\(\\)", "Mean", names(dataSum))
names(dataSum) <- gsub("-std\\(\\)", "StdDev", names(dataSum))
names(dataSum) <- gsub("-", "", names(dataSum))
names(dataSum) <- gsub("BodyBody", "Body", names(dataSum))
names(dataSum) <- gsub("\\(\\)", "", names(dataSum))

# Create independent data set with mean associated with each Subject/Activity combination
tidyDataSumMelt <- melt(dataSum, id = c("Subject","Activity"))
tidyDataSum <- dcast(tidyDataSumMelt, Subject+Activity ~ variable, mean)

# Write Data
write.csv(tidyDataSum, "tidyDataSum.csv", row.names=FALSE)
