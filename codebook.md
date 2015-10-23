**Background**
This dataset contains information about acceleration and velocity for individuals performing a variety of activities, measured on a Samsung Galaxy S II smartphone. Measurements were taken using the phone’s gyroscope and the phone’s accelerometer. The sample consists of 30 individuals from 19-48. Six activities were performed: walking, walking upstairs, walking downstairs, sitting, standing and laying. The sample was randomly partitioned into a training dataset (70%) and a test dataset (30%).

**Input files**
Data was downloaded from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
The following files were used in constructing outputs:
* train/y_train.txt – factor variable that contains activity codes for each record of training dataset 
* test/y_test.txt –factor variable that contains activity codes for each record of test dataset 
* activity_labels.txt – crosswalk showing text label associated with each activity code (eg. 1=standing)
* train/subject_train.txt –subject ids for each record in training measurements dataset
* test/subject_test.txt –subject ids for each record in test measurements dataset
* train/x_train.txt – dataframe containing frequency and acceleration measurements for training dataset
* test /x_test.txt – dataframe containing frequency and acceleration measurements for test dataset
* features.txt – column labels for both test and training datasets

**Data construction**
1. Read in text files to R
2. Extract variables containing the mean and standard deviation for each measurement from x_test and x_train files. These contain many other summary statistics for each measurement (mean absolute deviation, min, max, etc.) that are not extracted to the clean and tidy datasets. Note the mean frequency of each measurement was not extracted. 
3. Tidy measurement variable names contained in features.txt using the following operations
4. Make all names lowercase
5. Correct naming typo “bodybody” to “body” in several variables
6. Remove the following non-alphanumeric characters: -, (, )
7. Remove commas and additional spaces
8. Format names so “mean” or “sd” is clearly identified at the end of each name (eg. change “meanx” to “xmean” etc.)
9. Create full test and full training datasets by appending extracted mean and standard deviation variables, subject IDs, and activity codes horizontally, separately for test and training subsamples. For example, subj_test, y_test, and extracted variables from x_test were appended to create the full test dataset. 
10. Create new “group” variable in full test and training datsets to indicate which dataset the observation belongs to. This variable takes the value of “test” for all observations in test dataset, and “train” for each observation in training dataset.
11. Stack full test and full training datasets to create a combined test and training dataset.
12. Label activity codes with activity names using the information contained in activity_labels.
13. Save clean combined dataset “cleaned_data.txt”
14. Create tidy dataset by taking average of each variable by activity and subject. Note the “group” variable indicating test or training dataset will be constant within each subject ID.
15. Save tidy dataset “tidy_data.txt”

**Variable names**
Resulting cleaned_data file has multiple records for each individual-activity combination in the study. Resulting tidy_data file has one record (containing the average of each measurement variable) for each individual-activity combination in the study. 
* V1 - group – indicates if observation came from training or test subsample
* V2 - subjectid – individual’s unique ID
* V3 - activity – indicates which activity was undertaken to generate measurements (eg. sitting, standing, etc.)
* V4-V69 – measurement variables

Measurement variables are named according to the following conventions:
* “t” or “f” prefix indicates if the measurement is of time or frequency
* “sd” or “mean” suffix indicates if the measurement is a mean or standard deviation
* “x”, “y” or “z” in body of name indicates direction of measurement (eg. x-axis acceleration)

For definitions remaining portion of variable names, the original documentation in the “features_info.txt” file provides this description: 

> “The features selected for this database come from the accelerometer and gyroscope 3-axial raw > signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a > constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass > Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal > was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using > another low pass Butterworth filter with a corner frequency of 0.3 Hz. Subsequently, the body linear > acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and > tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the > Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, > tBodyGyroJerkMag). Finally a Fast Fourier Transform (FFT) was applied to some of these signals > producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, > fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). These signals were used to > estimate variables of the feature vector for each pattern: '-XYZ' is used to denote 3-axial signals in the X, > Y and Z directions.”

> Source: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public > Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on > Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, > Belgium 24-26 April 2013.

