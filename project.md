Initialisation of the project, setting the working directory etc
enabling Multicores, not sure if this helps 
http://machinelearningmastery.com/tuning-machine-learning-models-using-the-caret-r-package/

Loading Data
```{r, message=FALSE}
setwd("/cousera/")

library(caret)
library(doMC)
set.seed(1000)

registerDoMC(cores = 2)
```

masking the n/a and empty strings, no idea what #DIV/0! stands for but thrown out to
```{r, message=FALSE}
ignoreStrings <- c("NA","","#DIV/0!")
trainingRaw <- read.csv("pml-training.csv", na.strings=ignoreStrings)
trainingRaw <- trainingRaw[,8:160]
```
skipping username etc, "roll_belt" is the first intersting one

```{r, message=FALSE}
testingRaw <- read.csv("pml-testing.csv", na.strings=ignoreStrings)
testingRaw <- testingRaw[,8:160]
```
searching for near zero variance

```{r, message=FALSE}
noVariance <- nearZeroVar(trainingRaw)
str(noVariance)
  ```
those in variable noVariance have apparently very little variance

Removed the ones without Variance

```{r, message=FALSE}
trainingRawNoVariance <- trainingRaw[,-noVariance]
testingRawNoVariance <- testingRaw[,-noVariance]
```

the  NA fields are still there
```{r, message=FALSE}
str(trainingSet)
```
so next remove the NA Fields
```{r, message=FALSE}
nonEmptyFields <- names(trainingRawNoVariance[,colSums(is.na(trainingRawNoVariance)) == 0]);

trainingData <- trainingRawNoVariance[,c(nonEmptyFields)];

```

Calculating the out of Sample error
```{r, message=FALSE}
tmpTrain <- createDataPartition(y = trainingData$classe,
                               p = 0.8,
                               list = F)
trainingInt <- trainingData[tmpTrain,]
testingInt <- trainingData[-tmpTrain,]

modelRfOutOfSample <- randomForest(classe ~ ., method="parRF", data = trainingInt)

predictionsOutOfSample <- predict(modelRfOutOfSample, newdata = testingInt)

confusionMatrix(predictionsOutOfSample, testingInt$classe)

```


Random Forst is the one with the best error rate
```{r, message=FALSE}
modelRandomForest <- train(classe ~ ., method="parRF", data=trainingData)
predictTraining <- predict(modelRandomForest, trainingData)
```
check the training data / Print accuracy
Choosing random forrest seems to be the best matching one 


```{r, message=FALSE}
confMatrix <- confusionMatrix(predictTraining, trainingData$classe)
print(confMatrix$overall)

```
Confusion Matrix output 
```{txt}
Accuracy          Kappa  AccuracyLower  AccuracyUpper   AccuracyNull AccuracyPValue  McnemarPValue 
1.0000000      1.0000000      0.9998120      1.0000000      0.2843747      0.0000000            NaN 
```

 now predict on testdata and write for the quiz into a file
```{r, message=FALSE}


predictionTesting <- predict(modelRandomForest, testingRawNoVariance)

print(predictionTesting)

write.table(predictionTesting,file="pred.txt")

```

