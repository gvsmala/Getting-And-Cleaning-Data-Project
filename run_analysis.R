library(reshape2)

# Load activity labels and features
activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("./data/UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation and 
features_List <- grep(".*mean.*|.*std.*", features[,2])
features_List.names <- features[features_List,2]
features_List.names = gsub('-mean', 'Mean', features_List.names)
features_List.names = gsub('-std', 'Std', features_List.names)
features_List.names <- gsub('[-()]', '', features_List.names)

# Load the datasets
train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")[features_List]
trainActivities <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")[features_List]
testActivities <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge datasets and add labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", features_List.names)


# convert activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

# labels with descriptive variable names

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "./Getting-And-Cleaning-Data-Project/tidy.txt", row.names = FALSE, quote = FALSE)