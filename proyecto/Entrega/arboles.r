if(!require("party")){
	install.packages("party")
}
require("party")
if(!require("randomForest")){
	install.packages("randomForest")
}
require("randomForest")

gc()

aplicarDecisionTree <- function(data, formula=Climate ~ JanTemperature+FebTemperature+MarTemperature+AprTemperature+MayTemperature+JunTemperature+JulTemperature+AugTemperature+SepTemperature+OctTemperature+NovTemperature+DecTemperature+JanRain+FebRain+MarRain+AprRain+MayRain+JunRain+JulRain+AugRain+SepRain+OctRain+NovRain+DecRain+ATemperature+AMaxTemperature+AMinTemperature+APrecipitation){
	set.seed(0)

	ind <- sample(2, nrow(data),replace=TRUE,prob=c(0.7,0.3))
	trainData <- data[ind==1,]
	testData <- data[ind==2,]

	myFormula <- formula

	climate_ctree <- ctree(myFormula, data=trainData)

	plot(climate_ctree, type="simple")

	climate_pred <- predict(climate_ctree, newdata=testData)
	print(table(climate_pred,testData$Climate))
	print(sum(climate_pred==testData$Climate)/nrow(testData))
	evaluar(testData$Climate,climate_pred)
	return (climate_ctree)
}

aplicarRandomForest <- function(data, numArboles=10, formula=Climate ~ JanTemperature+FebTemperature+MarTemperature+AprTemperature+MayTemperature+JunTemperature+JulTemperature+AugTemperature+SepTemperature+OctTemperature+NovTemperature+DecTemperature+JanRain+FebRain+MarRain+AprRain+MayRain+JunRain+JulRain+AugRain+SepRain+OctRain+NovRain+DecRain+ATemperature+AMaxTemperature+AMinTemperature+APrecipitation){
	set.seed(0)

	ind <- sample(2, nrow(data),replace=TRUE,prob=c(0.7,0.3))
	trainData <- data[ind==1,]
	testData <- data[ind==2,]

	myFormula <- formula

	climate_rf <- randomForest(myFormula,data=trainData, ntree=numArboles, proximity=FALSE)

	plot(climate_rf)

	climate_pred <- predict(climate_rf, newdata=testData)
	print(table(climate_pred,testData$Climate))
	print(sum(climate_pred==testData$Climate)/nrow(testData))
	evaluar(testData$Climate,climate_pred)
	return (climate_rf)
}

evaluar <- function(valores, pred){
	precision <- sapply(levels(valores),function(x){
			truePositive <- sum((valores==x) & (pred==x))
			falsePositive <- sum(!(valores==x) & (pred==x))
			return (truePositive/(truePositive+falsePositive))
		})
	recall <- sapply(levels(valores),function(x){
			truePositive <- sum((valores==x) & (pred==x))
			falseNegative <- sum((valores==x) & !(pred==x))
			return (truePositive/(truePositive+falseNegative))
		})
	f1 <- (2*precision*recall)/(precision+recall)
	print("Precision:")
	print(precision)
	print("Recall: ")
	print(recall)
	print("F1: ")
	print(f1)
}