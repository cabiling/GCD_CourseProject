Code Book
=======================================================
The run_analysis.R script does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


Steps in Getting and cleaning the data.

1. Used the plyr package.
2. The data was dowloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and unzipped into the data folder using the download.unzip function.
3. Read and merged the training and test data using merge.data function in order to create a single data frame.
4. The mean and standard deviation for each measurement was then calculated using mean.std function.
5. The activities function was used to assign activity names to name the activities in the data set.
6. A dataframe combining the mean and std, acitivities and subjects was created using the bind.data function.
7. An independent tidy dataset with the average of each variable for each activity and each subject was created using the clean.data function.
8. The final output was saved into the data folder as a tab delimited file (UCI_HAR_Clean_Data.txt).  