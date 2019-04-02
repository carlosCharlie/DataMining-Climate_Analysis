rm(list=ls())
directory <- "./sample/datasets/climateKnowledge/"

filesOnDirectory <- list.files(directory)
datasets <- list()
for(nameOfFile in filesOnDirectory){
	
	nameOfCountry <- substr(nameOfFile, 1, nchar(nameOfFile)-4)
	fileToRead <- paste(directory,nameOfFile,sep="")
	dataset <- read.csv(fileToRead, header = TRUE, sep=",", dec=".",stringsAsFactor=FALSE)
	datasets <- c(datasets,list(name=dataset))
	names(datasets)[length(datasets)] <- nameOfCountry
}

for(country in datasets){
	for(i in 1:length(country)){
		sum(is.na(country[i]))
	}
}

plotMonthVs <- function(dataset, var1, years){
	months <- dataset$Month[dataset$Year==years]
	var <- dataset[var1][dataset$Year==years,]
	barplot(var, names.arg=months)
}

