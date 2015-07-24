### required package
library(reshape2)

## PART 1: Merges the training and the test sets to create one data set.
### first, load all six files
test_main <- read.table("test/X_test.txt", colClasses = "numeric")
   ### using colClasses makes it load somewhat faster
test_subject <- read.table("test/subject_test.txt")
test_activity <- read.table("test/y_test.txt")
train_main <- read.table("train/X_train.txt", colClasses = "numeric")
   ### using colClasses makes it load somewhat faster
train_subject <- read.table("train/subject_train.txt")
train_activity <- read.table("train/y_train.txt")
### next, combine all three types across test and training data sets
main_data <- rbind(test_main, train_main)
both_subject <- rbind(test_subject, train_subject)
both_activity <- rbind(test_activity, train_activity)
### now include subject and activity information within main data frame
main_data$subject <- both_subject$V1
   ### this will add the subject and activity columns at the end,
   ### leaving the column numbers for the measurements unchanged
main_data$activity <- both_activity$V1

## PART 2: Extracts only the measurements on the mean and standard deviation for each measurement.
### first, read in the features
features <- read.table("features.txt")$V2
   ### this file has two columns; we only want the names in column 2
### next, find those that correspond to mean, standard deviations, and subject and activity
cols_mean <- grep("mean()", features, fixed=TRUE)
   ### this intentionally excludes variables of the type "meanFreq()",
   ### for which there is no corresponding standard deviation
cols_std <- grep("std()", features, fixed=TRUE)
cols_sa <- which(colnames(main_data) == "subject" | colnames(main_data) == "activity")
cols_all <- sort(c(cols_mean, cols_std, cols_sa))
   ### combine and sort to keep original ordering
### now select for only those columns that are of interest
main_data <- main_data[,cols_all]

## PART 3: Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("activity_labels.txt")$V2
   ### again, we only want the names in column 2
main_data$activity <- activity_labels[main_data$activity]

## PART 4: Appropriately labels the data set with descriptive variable names. 
### first, form all the features with subject and activity added
features_all <- c(as.character(features), "subject", "activity")
   ### convert to character to facilitate combining with new character strings
### as before, select for only those columns that are of interest
features_used <- features_all[cols_all]
names(main_data) <- features_used

## PART 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
### first, melt by subject and activity, yielding one long data set
melted_data <- melt(main_data, id=c("subject", "activity"))
### zero-padded subject number -- so that lexical sorting yields correct results on numbers
zpsn <- sprintf("%02d", as.numeric(as.character(melted_data$subject)))
### next generate a new column as an outer product of subject and activity
melted_data$subject.activity <- as.factor(paste(zpsn, melted_data$activity, sep = "."))
### next cast back into a descriptive data frame based on subject and activity
tidy_data <- dcast(melted_data, subject.activity ~ variable, mean)
### now reconstitute the original subject and activity values as separate columns
tidy_data$subject <- as.numeric(sub("\\..*", "", tidy_data$subject.activity))
tidy_data$activity <- as.factor(sub(".*\\.", "", tidy_data$subject.activity))
### finally reorder so that subject and activity replace their outer product
ncol <- length(cols_all)
tidy_data <- tidy_data[,c(ncol, (ncol+1), 2:(ncol-1))]

### not technically part of this file, but was used to generate output
write.table(tidy_data, file="tidy_data.txt", row.name=FALSE)
