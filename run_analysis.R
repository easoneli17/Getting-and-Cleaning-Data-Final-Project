#loading in the data:
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
setwd("C:/Users/Lizzie Eason/Desktop/Coursera/3_GandCData")
f <- file.path(getwd(), "getdata_projectfiles_UCI HAR Dataset.zip")
download.file(url, f)
unzip("getdata_projectfiles_UCI HAR Dataset.zip")
setwd("C:/Users/Lizzie Eason/Desktop/Coursera/3_GandCData/UCI HAR Dataset")
a<- read.table("./test/subject_test.txt",header=FALSE) 
b<- read.table("./test/X_test.txt",header=FALSE) 
c<- read.table("./test/y_test.txt",header=FALSE) 
d<- read.table("./train/subject_train.txt",header=FALSE) 
e<- read.table("./train/X_train.txt",header=FALSE) 
f<- read.table("./train/y_train.txt",header=FALSE) 
g<- read.table("./features.txt",header=FALSE) 

#1
#form for merging:
#g
#e, d, f
#b, a, c

top<-cbind(e,d,f)
bottom<-cbind(b,a,c)
full<-rbind(top,bottom)
dim(full)
#[1] 10299   563
colnames(full)<-c(as.character(g$V2),"subject","activity")

#2: extracting only columns with mean or standard deviation
i<-full[,c(grep('mean|std', names(full), value = TRUE),"subject","activity")]

h<- read.table("./activity_labels.txt",header=FALSE) 

#3: using descriptive activity names for the columns
colnames(h)<-c("activity","description")
library(dplyr)
j<-left_join(i,h,by="activity")
k<-j %>% select(-(activity)) %>% rename(activity=description)

#4: making the names more descriptive
names(k)<-gsub("^t", "Time",names(k))
names(k)<-gsub("^f", "Frequency",names(k))
names(k)<-gsub("Gyro","Gyroscope",names(k))
names(k)<-gsub("Acc","Accelerometer",names(k))
names(k)<-gsub("Mag","Magnitude",names(k))
names(k)<-gsub("BodyBody","Body",names(k))

#5: independent tidy data set with the average of each variable 
#for each activity and each subject.
new<- k %>% group_by(subject,activity) %>% summarize_each(funs(mean))

write.table(new,file="final.txt",row.name=FALSE)
