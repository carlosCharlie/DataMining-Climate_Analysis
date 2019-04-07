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
datasets <- lapply(datasets,function(country){
	i<-1
	while (i <= nrow(country)){
		if(sum(is.na(country[i,])) == (length(country)-1)){
			country <- country[-i,]
		}
		else{
			i <- i+1
		}
	}
	 country
	})