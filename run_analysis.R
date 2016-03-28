#First make sure that you set the working directory to the folder that contains the data
  #1.Merges the training and the test sets to create one data set.
    #read Data files
      #1 Train datasets
      trainsubjectTable <- read.table("train/subject_train.txt")
      trainXTable <- read.table("train/X_train.txt")
      trainYTable <- read.table("train/y_train.txt")
      
      #2 Test datasets
      testsubjectTable <- read.table("test/subject_test.txt")
      testXTable <- read.table("test/X_test.txt")
      testYTable <- read.table("test/y_test.txt")
      
      #3 read feature and activity labels
      featureTable <- read.table("features.txt")
      activityTable <- read.table("activity_labels.txt")
      
    #Merge the train and test data sets
      #1 cbind the train dataset and rename
        TrainData<-cbind(trainsubjectTable,trainYTable,trainXTable)
        names(TrainData)<-c("SubjectID","ActivityID",as.character(featureTable$V2))
        
      #2 cbind the test dataset and rename
        TestData<-cbind(testsubjectTable,testYTable,testXTable)
        names(TestData)<-c("SubjectID","ActivityID",as.character(featureTable$V2))
      #3 rbind the TrainData and the TestData 
        Data<-rbind(TrainData,TestData)
  
  #2.Extracts only the measurements on the mean and standard deviation for each measurement.
    indices<-grep("mean\\(\\)|std\\(\\)",names(Data))
    DataMeanStd<-Data[,c(1,2,indices)]
  
  #3.Uses descriptive activity names to name the activities in the data set
    names(activityTable)=c("ID","Activity")
    Data<-merge(DataMeanStd,activityTable,by.x="ActivityID",by.y="ID",all=T)
    factor(Data$Activity,activityTable$Activity)
    Data<-Data[,2:ncol(Data)]
  
  #4.Appropriately labels the data set with descriptive variable names.
    names(Data)<-gsub("\\(|\\)","",names(Data))
    names(Data)<-gsub("^t","Time",names(Data))
    names(Data)<-gsub("^f","Fourier",names(Data))
    names(Data)<-gsub("Acc","Acceleration",names(Data))
    names(Data)<-gsub("Mag","Magnitude",names(Data))
    names(Data)<-gsub("-mean","Mean",names(Data))
    names(Data)<-gsub("-std","Std",names(Data))
    names(Data)<-gsub("-X","X",names(Data))
    names(Data)<-gsub("-Y","Y",names(Data))
    names(Data)<-gsub("-Z","Z",names(Data))
  
  #5. From the data set in step 4, creates a second, independent tidy data set with the average of 
  #   each variable for each activity and each subject.
  
    library(reshape2)
    meltData<-melt(Data,id=c("SubjectID","Activity"))
    TidyData<-dcast(meltData,SubjectID+Activity~variable,mean)
    save(TidyData,file="TidyData.Rda")   
