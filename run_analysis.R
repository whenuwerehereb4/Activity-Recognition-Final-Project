dataset_url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataset_dest<-"./SamsungAccelerometers.zip"

if (!file.exists(dataset_dest)) {
        download.file(dataset_url,destfile = dataset_dest)
        unzip("SamsungAccelerometers.zip")
}

## SUBJECT LISTS ## 
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")

#ASSIGN COLUMN NAMES TO "Subject" DATA FRAME #
colnames(subject_test) <- "subject"
colnames(subject_train) <- "subject"

## THESE ARE THE ACTIVITY LABEL ASSIGNMENTS (MADE MANUALLY BY OBSERVERS OF THE VIDEOS)
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")

## 3. Uses descriptive activity names to name the activities in the data set

## THERE WERE 6 POSSIBLE ACTIVITY LABELS: 

activity_list<-read.table("./UCI HAR Dataset/activity_labels.txt")
#1 WALKING
#2 WALKING_UPSTAIRS
#3 WALKING_DOWNSTAIRS
#4 SITTING
#5 STANDING
#6 LAYING


## Create a column listing the activity rather than the numerical value
activity_test<-merge(y_test,activity_list,by="V1",all=TRUE)
activity_train<-merge(y_train,activity_list,by="V1",all=TRUE)

# Remove the numerical value column since we don't need it anymore
# use drop=FALSE so the object stays a data frame so we can label the column in the nest step
activity_train<-activity_train[,2, drop=FALSE]
activity_test<-activity_test[,2, drop=FALSE]

#Assign "activity"name to columns

colnames(activity_test) <- "activity"
colnames(activity_train) <- "activity"


## THESE ARE THE INDIVIDUAL MEASUREMENTS OF THE ACCELOROMETER AND GRYOSCOPE FEATURES PERFORMED IN THE ANALYSIS ##
x_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
x_train<-read.table("./UCI HAR Dataset/train/X_train.txt")


#> dim(x_test)
#[1] 2947  561

## 4. Uses descriptive activity names to name the activities in the data set

## FEATURE LIST ##
feature_list<-read.table("./UCI HAR Dataset/features.txt")

## ASSIGNING VARIABLE NAMES TO THE MEASUREMENTS DATA BASED ON FEATURE LIST 
#1st column in feature_list is an integer vector so it should not be included (thus the column name assignments are based on column 2 )

colnames(x_test) <- as.character(feature_list[,2]);
colnames(x_train) <- as.character(feature_list[,2]);


## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

##Subset the data frame to extracts only the measurements on the mean and standard deviation for each measurement.

feature_train<-subset(x_train[grepl("mean|std",colnames(x_train))])

# go from 563 to 79 factors in the data set
# dim(feature_train)
# [1] 7352   79
# dim(x_train)
# [1] 7352  563

feature_test<-subset(x_test[grepl("mean|std",colnames(x_test))])



##COMBINE ALL THE DATA ASSOCIATED WITH THE OBSERVATIONS INTO A SINGLE DATA FRAME -- ONE EACH FOR THE "train" and "test" data sets.  
## THESE DATA FRAMES COMBINE THE 1) SUBJECT, 2) ACTIVITY AND 3) MEASUREMENTS/FEATURES DATA FRAMES (in that order) INTO A SINGLE DATA FRAME:

subjxactivityxfeature_test <- cbind(subject_test,activity_test,feature_test)
subjxactivityxfeature_train <- cbind(subject_train,activity_train,feature_train)

## 1. Combines the training and the test sets to create one data set.
subjxactivityxfeature_COMBINED<-rbind(subjxactivityxfeature_test,subjxactivityxfeature_train)

#dim(subjxactivityxfeature_COMBINED)
#[1] 10299    81

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(reshape2)
## MELT THE COMBINED DATA SET ON *EACH ACTIVTY AND EACH SUBJECT* IN ORDER TO BE ABLE TO EASILY CALCULATE MEAN VALUES IN THE NEXT STEP
subjxactivityxfeature_COMBINED_MELT<- melt(subjxactivityxfeature_COMBINED,id=c("subject","activity"),measure.vars=c(3:81))

##NOW USE DECAST TO CALCULATE MEANS  SO NOW WE HAVE ONE OBSERVATION (I.E. ONE MEAN VALUE) FOR  *EACH ACTIVITY AND EACH SUBJECT*,  
subjxactivityxfeature_COMBINED_MELT_AVERAGES<-dcast(subjxactivityxfeature_COMBINED_MELT,subject + activity ~ variable,mean)


# dim(subjxactivityxfeature_COMBINED)
# [1] 10299    81

#dim(subjxactivityxfeature_COMBINED_MELT)
#[1] 813621      4

# dim(subjxactivityxfeature_COMBINED_MELT_AVERAGES)
#[1] 40 81

### THIS SEEMS LIKE A VERY LOW # OF OBSERVATIONS AT THIS LAST STEP.  NEED TO CONFIRM THAT THIS IS CONSISTENT WITH THE DATA FROM EARLIER STEPS ### 

# if we just review subject 1 in the MELT and the COMBINED_MELT tables, for instance 
subset(subjxactivityxfeature_COMBINED_MELT_AVERAGES[1,1:10],subject==1)
#subject activity tBodyAcc-mean()-X tBodyAcc-mean()-Y
#1       1  WALKING         0.2656969       -0.01829817
#tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y
#1        -0.1078457       -0.5457953       -0.3677162
#tBodyAcc-std()-Z tGravityAcc-mean()-X tGravityAcc-mean()-Y
#1       -0.5026457            0.7448674          -0.08255626

table(subjxactivityxfeature_COMBINED_MELT$subject,subjxactivityxfeature_COMBINED_MELT$activity)

#       LAYING SITTING STANDING WALKING WALKING_DOWNSTAIRS
# 1       0       0        0    27413                  0
#        WALKING_UPSTAIRS
#1                 0

##.... they both indicate that only the "WALKING" activity was observed for this subject, to the results appear to make sense, after all 


## Create Final Data set in the form of a txt file as per the "Submission" instructions
write.table(subjxactivityxfeature_COMBINED_MELT_AVERAGES,"./FinalDataSet_CourseraClass_GettingData.txt",row.names = FALSE)

## Have the output of running this code be the final "tidy" melted and combined data set 
print(subjxactivityxfeature_COMBINED_MELT_AVERAGES)
