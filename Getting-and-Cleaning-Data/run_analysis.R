#to download the file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

#to unzip the file
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#to list the unzipped files from the folder
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

#to read the activity file
dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

#to read the subject file 
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

#to read the features file 
dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

#to see the property of the test activity
str(dataActivityTest)

#to see the property of the training activity
str(dataActivityTrain)

#to see the property of the training subject
str(dataSubjectTrain)

#to see the property of the test subject
str(dataSubjectTest)

#to see the property of the test features
str(dataFeaturesTest)

#to see the property of the training features
str(dataFeaturesTrain)


# merging training and test data
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

#giving name to the variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

#merging colun to create the data frame for all data
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#subsetting names of features by mean and standard deviation
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

#subsetting data fram by subsetted names of feature
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

# to check the structure of the data frame
str(Data)

# reading decriptive activity names from text file "activity_labels,txt"
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

head(Data$activity,30)

#labelling the dataset with descriptive variable names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

names(Data)

# creating tidy data using plyr
library(plyr)
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)


