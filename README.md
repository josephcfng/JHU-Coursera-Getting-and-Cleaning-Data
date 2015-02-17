### Introduction

run_analysis.R takes the Samsung dataset as provided on the Project submission page,
merged the training and the test datasets, labelled each observation with the
corresponding activity (with descriptive names in activity_labels.txt) and the 
subject ID. It then labels the variables with the descriptive names as provided 
in features.txt, and selects only variables associated with means and standard 
deviations of measurements. 

This data is used to generate an independent tidy dataset: grouped by the subject ID and 
Activity, and summarized with averages of each mean/standard deviation variable 
with respect to each subject and each activity (s)he engages in. This tidy dataset is
written out in "final_data.txt" in the working directory.

### Packages

'data.table' is utilized for faster and more memory efficient manner of reading 
datasets into R. 'dplyr' is utilized for more convenient data frame manipulation. 
The script has to be run with these two packages installed.

### Explanation

Explanation of the script is in the run_analysis.R alongside with the script itself.
The tidy dataset output can be read in R through read.table("final_data.txt",header=TRUE)

### Codebook

The dataset output contain the following variables:

Columns 1 and 2 - 
1.  Subject: Subject ID (1 - 30).
2.  Activity: The activity that the subject is engaged in when recorded the observations.
    Data here are descriptive names taken from activity_labels.txt with the numeric index.

Columns 3 to 68 - 
Column names are in the form "Average_(some measurement)". This denotes the average of that
measurement in the merged, labelled and filtered dataset. Thus that measurement must either
be mean or standard deviation of some measurements. I take the average of the (mean/standard
deviation) of those measurements with respect to subject ID and activity.

The whole table is therefore a summary table showing averages of (mean/standard deviation)
of measurements recorded in the experiments, with respect to each subject and each activity.
