Initialisation of the project, setting the working directory etc
enabling Multicores, not sure if this helps 
http://machinelearningmastery.com/tuning-machine-learning-models-using-the-caret-r-package/


```{r, message=FALSE}

Loading Data
setwd("/cousera/")


library(caret)
library(doMC)

set.seed(56773)

registerDoMC(cores = 2)
```

masking the n/a and empty strings, no idea what #DIV/0! stands for but thrown out to
```{r, message=FALSE}
trainingRaw <- read.csv("pml-training.csv", na.strings=c("NA","","#DIV/0!"));
```
skipping username etc, "roll_belt" is the first intersting one
```{r, message=FALSE}
trainingRaw <- trainingRaw[,8:160];
testingRaw <- read.csv("pml-testing.csv", na.strings=c("NA","#DIV/0!",""));
```
skipping username etc, "roll_belt" is the first intersting one

```{r, message=FALSE}
testingRaw <- testingRaw[,8:160];
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
 Choosing random Forrest seems to be the best learning one 
 
```{r, message=FALSE}
modelRandomForest <- train(classe ~ ., method="parRF", data=trainingData)
predictTraining <- predict(modelRandomForest, trainingData)
```
 check the training data
```{r, message=FALSE}
confMatrix <- confusionMatrix(predictTraining, traindata$classe)
print(confMatrix$overall)
```

 now predict on testdata
```{r, message=FALSE}
predictionTesing <- predict(modelRandomForest, testingRawNoVariance)
print(predictionTesing)
```

write.table(prediction,file="pred.txt")
