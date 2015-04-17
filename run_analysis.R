## read and get the datasets
setwd("C:/Users/Yuhua/Desktop/Data Science/4/UCI HAR Dataset")
subtest<-read.table("test/subject_test.txt")
xtest<-read.table("test/X_test.txt")
ytest<-read.table("test/y_test.txt")
subtrain<-read.table("train/subject_train.txt")
xtrain<-read.table("train/X_train.txt")
ytrain<-read.table("train/y_train.txt")

## 1. Merges the training and the test sets to create one data set.
da_sub<-rbind(subtrain,subtest)
da_x<-rbind(xtrain,xtest)
da_y<-rbind(ytrain,ytest)

## read features table, name colume datasets in da_x by corresponding feature names.
features<-read.table("features.txt")
names(da_x)=features$V2

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
subfeatures<-da_x[grep("mean\\(\\)|std\\(\\)",features[,2])]

## 3. Uses descriptive activity names to name the activities in the data set.
activity<-read.table("activity_labels.txt")
da_y[,1]<-activity[da_y[,1],2]

## name columes in da_y and da_sub
names(da_y)<-"activity"
names(da_sub)<-"subject"

## merge all datasets in one table.
da<-cbind(subfeatures,da_y,da_sub)

## 4. Appropriately labels the data set with descriptive variable names.
names(da)<-gsub("^t","time",names(da))
names(da)<-gsub("^f","frequency",names(da))
names(da)<-gsub("Acc","Accelerometer",names(da))
names(da)<-gsub("Gyro","Gyroscope",names(da))
names(da)<-gsub("Mag","Magnitude",names(da))
names(da)<-gsub("BodyBody","Body",names(da))

## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyda<-aggregate(. ~subject + activity, da, mean)
write.table(tidyda, file = "tidy_data_set.txt",row.name=FALSE)
