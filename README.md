The attached run_analysis.R script does the following, provided the zip file containing the data is unzipped in the working directory:

1. Read the training data set ("train/X_train.txt"). Then, read the corresponding activity ids ("train/y_train.txt") and the corresponding subject ids ("train/subject_train.txt"). Create new variables for the activity ids and subject ids in the training dataset.

2. Repeat the step 1 for the test dataset.

3. Merge the training and test datasets.

4. Note that the raw dataset from step 3 does not have any column names. Set the names from the features.txt file.

5. Select only the columns that denote either the mean or standard deviation of the features/measurements by using the grep function. This yields a total of 66 measurements.

6. Melt the dataset from step 5 so that the names and values of the measurements are transposed into two columns, "variable" and "value". This facilitates the calculation of mean for each measurement by activity id and subject id.

7. Use the aggregate function to calculate the mean for each measurement.

8. The dataset from step 7 is the long form of the required output. Number of rows = 30 (number of subjects) * 6 (number of activities) * 66 (number of measurements) = 11880
and Number of cols = 4 (activityid, subid, variable, value).

9. Use the gsub function to remove the characters "-", "(" and ")" from the variable column. 

10. Cast the dataset to convert it to a wide format. This function writes out each "variable" as an attribute with the corresonding "value".

11. Read the activity_labels.txt file. Merge the dataset from step 10 with the activity labels dataset to substitute the activity for activity id.

12. Write out the final wide dataset using the write.table function. This is the submitted dataset.

13. As a quick reference, code to read the wide dataset from disk into R is included in addition to a couple of sanity checks on the read data including checking for number of rows/columns and the column names.

The Codebook.md file contains description of all the variables in the submitted dataset.

