# Final-Project-Getting-and-Cleaning-Data Intro  
*Source for the Intro:*
https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-
cleaning-data-course-project

The purpose of this project is to demonstrate your ability to collect, work
with, and clean a data set. The goal is to prepare tidy data that can be used
for later analysis. One of the most exciting areas in all of data science right
now is wearable computing - see for example this article . Companies like
Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms
to attract new users. The data linked to from the course website represent data
collected from the accelerometers from the Samsung Galaxy S smartphone. A full
description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+
Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR
%20Dataset.zip
%
You should create one R script called run_analysis.R that does the following.

Merges the training and the test sets to create one data set. Extracts only the
measurements on the mean and standard deviation for each measurement. Uses
descriptive activity names to name the activities in the data set Appropriately
labels the data set with descriptive variable names.

From the data set in step 4, creates a second, independent tidy data set with
the average of each variable for each activity and each subject.

## Overview of steps I took to collect, work with, and clean this data set 
*Note: all of these steps are further elucidated in the commented sections of
the R code found in the file "run_analysis.R"*

1. Data was downloaded from the source referred to above and unzipped.

2. the Subject , Activity and Feature (all the observed/measured data was
included in this file) files were read into R for both the "train" and "test"
sets (for each set there were 3 files).

3. Six separate data frames were created from the 6 text files and all of these
data frames were assigned column labels. - The subject and activity data frames
consisted only of single columns, but the 2 feature data frames had to be
assigned labels based on a character vector of 561 elements.

4. After column labels were assigned, I extracted out only the much smaller set
of features(i.e. columns) from the "train" and "test data sets that  I was
interested in per the assignment instructions. - To accomplish this, a subset of
the data including only features based on mean or standard deviation values was
identified (using the grepl function in the dplyr package) to generate 2 new
data frames.

5. Now that all of the individual data frames were the way I wanted them, I
combined them together in a 2 step process, 1st creating 2 "train" and "test"
data frames with cbind and then combining the complete "train" and "test" data
frames into a single data frame.

6. At this point, I had the complete, tidy data set that combined all the
observations from both the "train" and "test" sets.

7. Now that I had a complete data set, I could create a second data set
consisting of mean values for EACH ACTIVTY AND EACH SUBJECT (per the assignment
instructions).  This was done in a 2 step process of: 1) "melting" the data
(with subject and activity serving as the ID values and all the features
"melted" in a single "variable" column); and 2) using dcast to make the data
frame "wide" again and calculate means for each of the features based on the ID
columns.

8. A text file is generated from this data frame in the R script via the
write.table function.

9. As the last step in the process (and in the R script/routine), the first 2
rows of this significantl shrunken data set (shrunken from 563 features down to
79) is printed to the console.

##Important notes regarding the R script:  
* The "run_analysis.R" script is entirely self-sufficient, including downloading
the zip file and unzipping it if you have not already done so (if the file
already exists in your working directory it will skip this step).

* You will only need to decide which working directory you wish to store this
information, as that step is not included in the script (it assumes you have
already selected your preferred working directory)

##Comments regarding my interpretation of the term "tidy data sets" as it
##relates to this assignment:
* The standard components of a "tidy data set" are as follows: 1. Each variable
you measure should be in one column; 2. Each different observation of that
variable should be in a different row; 3. There should be one table for each
"kind" of variable; 4. If you have multiple tables, they should include a column
in the table that allows them to be linked

* How my final data set meets this definition : 1. Each variable is in a single
column in the data frame 2. Each observation is in a different row.  For
purposes of this data set, an observation was defined as a single
subject-activity pair (e.g. subject 1 walking= 1 observation) 3. all variables
are of the same kind so there is no need for more than one table 4. not
applicable (see #3)
