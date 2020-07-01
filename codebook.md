#Code book for run_analysis.R

##Add libraries

The libraries data.table and dplyr are required for the code. So there were called at the beggining of the script.

```
library(data.table)
library(dplyr)
```

##Download data set

It is checked first if the dataset it has been already downloaded from the website and stored in the dataset folder. Also file unzip is required in the dataset folder.

```
if(!file.exists("./dataset")){
	dir.create("./dataset")
	download.file(url,destfile="./dataset/data.zip",exdir="./dataset")
	unzip(zipfile="./dataset/data.zip",exdir="./dataset")
}
if(file.exists("./dataset")){
print("Data downloaded") #Download checker
}
```

##Read data

Subjects, features and the activities are needed for the final dataset. These variables are being read by the read.table command and its path into the folder.

```
testsub <- read.table("./dataset/UCI HAR Dataset/test/subject_test.txt")
```

For the feature data is required to select the variables that shows mean and standard deviation. The grep command allows to get the data from the column names. 

```
na <- read.table("./dataset/UCI HAR Dataset/features.txt")
names(feat) <- na$V2
sm <- sort(c(grep("std\\(\\)",names(feat)),grep("mean\\(\\)",names(feat))))
feat <- feat[,sm]
```

The activity data is initially an integer vector with numbers from 1 to 6. The labels corresponding each number are given by the activity_labels.txt. 

```
na <- read.table("./dataset/UCI HAR Dataset/activity_labels.txt")
for(i in 1:6){acti[acti==i] <- na$V2[i]}
```

Finally subjects, activities and their relate variables are merged in to a big data frame.

```
DT <- data.frame(subj,acti,feat)
```

##Label data set

In order to have descriptive variable names, some headers were modified. For instance, dots are replaced by spaces, some upper cases changed by lower cases, parenthesis removed thanks to the gsub function.

```
na <- gsub("^f","Frequency",na)
na <- gsub("^t","Time",na)
na <- gsub("Gyro"," gyroscope",na)
```

##Create independent data set

The final data set comprises the mean values of each variable grouped by subject and activity. The dplyr package and its pipelines are used for these calculations.

```
dt <- DT %>% group_by(Subject,Activity) %>% summarize_at(vars(na[3:68]),mean)
```

Finally, the data set is written as a table into the "dt.txt" file.

```
write.table(dt,"dt.txt",row.name=FALSE)
```
