Loading Data
setwd("/cousera/")


library(caret)
library(doMC)

set.seed(56773)

registerDoMC(cores = 4)

# throwing out n/a strings
trainingRaw <- read.csv("pml-training.csv", na.strings=c("NA","#DIV/0!",""));
# skipping username etc, "roll_belt" is the first intersting one
trainingRaw <- trainingRaw[,8:160];

testingRaw <- read.csv("pml-testing.csv", na.strings=c("NA","#DIV/0!",""));
# skipping username etc, "roll_belt" is the first intersting one
testingRaw <- testingRaw[,8:160];

# searching for near zero variance

noVariance <- nearZeroVar(trainingRaw)

#  str(noVariance)
 7  10  19  44  45  46  47  48  49  50  51  52  68  71  72  74  75  82  85  94 120 123 124 127 130 132 135 136 137 138 139 140 141 142 143
-> those coloumns have apparently very little variance

# Removed the ones without Variance
trainingRawNoVariance <- trainingRaw[,-noVariance]
testingRawNoVariance <- testingRaw[,-noVariance]


# so lots of NA fields are still there
str(trainingSet)
# so next remove the NA Fields

nonEmptyFields <- names(trainingRawNoVariance[,colSums(is.na(trainingRawNoVariance)) == 0]);

trainingData <- trainingRawNoVariance[,c(nonEmptyFields)];


# Choosing random Forrest
modelRandomForest <- train(classe ~ ., method="parRF", data=trainingData)
predict <- predict(modelRandomForest, trainingData)
# check the training data
confMatrix <- confusionMatrix(predict, traindata$classe)
print(confMatrix$overall)
# now predict
prediction <- predict(modelRandomForest, testingRawNoVariance)
print(prediction)
