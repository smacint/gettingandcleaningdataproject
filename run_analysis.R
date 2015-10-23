setwd("C:/Users/SMacIntyre/Desktop/R/Getting and cleaning data/Course Project")

##Download data
	sink(file="run_analysis_date.txt") #start log file to record date of download
	
	if(!file.exists("data")) {		#check for directory to house downloads
		dir.create("data")	#create directory if it doesn’t exist
	}
	fullurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2
		FUCI%20HAR%20Dataset.zip"
	download.file(fullurl, destfile="./data/data.zip") #download zip file
	unzip("./data/data.zip", exdir="data") #unzip in data directory
	dl<-paste("Date of download:", date())
	print(dl)
	
	unlink("run_analysis_date.txt")

##Read in test, training and features datasets
	#activity variable
	y_train<-read.table("./data/UCI HAR Dataset/train/y_train.txt")
	colnames(y_train)<-"activity"
	y_test<-read.table("./data/UCI HAR Dataset/test/y_test.txt")
	colnames(y_test)<-"activity"
	activity_labels<-read.table("./data/UCI HAR Dataset/activity_labels.txt")
	activity_labels$V2<-tolower(activity_labels$V2)

	#measurements
	x_train<-read.table("./data/UCI HAR Dataset/train/X_train.txt")
	x_test<-read.table("./data/UCI HAR Dataset/test/X_test.txt")
	
	#subject ID	 
	subj_train<-read.table("./data/UCI HAR Dataset/train/subject_train.txt")
	colnames(subj_train)<-"subjectid"
	subj_test<-read.table("./data/UCI HAR Dataset/test/subject_test.txt") 
 	colnames(subj_test)<-"subjectid"

	#Measurement colnames for both test and training datasets
	features<-read.table("./data/UCI HAR Dataset/features.txt")	#activity colnames
	measurements<-features$V2

##Extract variable positions with mean and stdev measurements
	#Return vector with numbers for cols that contain means
	means<-grep("mean()", measurements, fixed=TRUE) #return vector with cols containing means

	#Return vector with number for variables that contain st devs
	stdevs<-grep("std", measurements) 
	
	#Combine means and stdevs vectors to show all vectors we need to extract
	extractvars<-c(means, stdevs)

##Tidy up column names
	#save lower case version of variable names
	names<-tolower(measurements[extractvars])
	#correct "bodybody" error to "body"
	names<-gsub("bodybody", "body", names)
	#remove "-", "()", " "
	rem<-c("-", "(", ")", " ")
	for(i in rem) {
		names<-gsub(i, "", names, fixed=TRUE)
	}
	#Format names so mean and sd are clearly identified at end of name
	from<-c("meanx", "meany", "meanz", "stdx", "stdy", "stdz")
	to<-c("xmean", "ymean", "zmean", "xstd", "ystd", "zstd")
	for(i in 1:length(from)) {
		names<-gsub(from[i], to[i], names)
	}

##Extract appropriate measurement variables from test and training datasets
	x_test_extract<-x_test[,extractvars]
	x_train_extract<-x_train[,extractvars]
	#label variables
	colnames(x_test_extract)<-names
	colnames(x_train_extract)<-names


##Assemble test and training datasets
	test<-data.frame(cbind(group="test", subj_test, y_test, x_test_extract))
	train<-data.frame(cbind(group="train", subj_train, y_train, x_train_extract))
	data<-rbind(test, train)

##Convert activity variables (numeric) to factor
	data$activity<-factor(data$activity, labels=activity_labels$V2)

##Create tidy dataset with avg of each variable by activity and subject
	tidy_data<-aggregate(data[,4:ncol(data)], 
		list(data$group, data$subjectid, data$activity), mean)
	colnames(tidy_data)[1:3]<-c("group", "subjectid", "activity")

##Write intermediate and tidy datasets
	write.table(data, file="cleaned dataset.txt", row.name=FALSE)
	write.table(tidy_data, file="tidy_data.txt", row.name=FALSE)

unlink("run_analysis_date.txt")	
	



