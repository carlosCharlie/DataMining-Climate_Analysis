if(!require("party")){
	install.packages("party")
}
require("party")
if(!require("randomForest")){
	install.packages("randomForest")
}
require("randomForest")

gc()

dataset <- read.csv("modify/datasets/datasetFinal/climateMarked.csv",header=TRUE)

data <- dataset[,(colnames(dataset)!="Country" & colnames(dataset)!="Year")]

aplicarDecisionTree <- function(data, formula=Climate ~ JanTemperature+FebTemperature+MarTemperature+AprTemperature+MayTemperature+JunTemperature+JulTemperature+AugTemperature+SepTemperature+OctTemperature+NovTemperature+DecTemperature+JanRain+FebRain+MarRain+AprRain+MayRain+JunRain+JulRain+AugRain+SepRain+OctRain+NovRain+DecRain+ATemperature+AMaxTemperature+AMinTemperature+TotalPrecipitation){
	set.seed(0)

	ind <- sample(2, nrow(data),replace=TRUE,prob=c(0.7,0.3))
	trainData <- data[ind==1,]
	testData <- data[ind==2,]

	myFormula <- formula

	climate_ctree <- ctree(myFormula, data=trainData)

	plot(climate_ctree, type="simple")

	climate_pred <- predict(climate_ctree, newdata=testData)
	print(table(climate_pred,testData$Climate))
}

aplicarRandomForest <- function(data, numArboles=10, formula=Climate ~ JanTemperature+FebTemperature+MarTemperature+AprTemperature+MayTemperature+JunTemperature+JulTemperature+AugTemperature+SepTemperature+OctTemperature+NovTemperature+DecTemperature+JanRain+FebRain+MarRain+AprRain+MayRain+JunRain+JulRain+AugRain+SepRain+OctRain+NovRain+DecRain+ATemperature+AMaxTemperature+AMinTemperature+TotalPrecipitation){
	set.seed(0)

	ind <- sample(2, nrow(data),replace=TRUE,prob=c(0.7,0.3))
	trainData <- data[ind==1,]
	testData <- data[ind==2,]

	myFormula <- formula

	climate_rf <- randomForest(myFormula,data=trainData, ntree=numArboles, proximity=FALSE)

	plot(climate_rf)

	climate_pred <- predict(climate_rf, newdata=testData)
	print(table(climate_pred,testData$Climate))
}