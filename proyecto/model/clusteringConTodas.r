source("modify/limpiarDataset.r")

if(!require(clue)){
	install.packages("clue")
}
require(clue)

data <- read.csv("modify/datasets/datasetFinal/climate.csv", header=TRUE)

dataNormalized <- normalizarANormal(data)

meanNormalized <- dataNormalized[[2]]
stdNormalized <- dataNormalized[[3]]
dataNormalized <- as.data.frame(dataNormalized[[1]])

aplicarKmeans <- function(data, numberOfClusters=4, conjuntoVar=3:length(data)){
	result <- kmeans(data[,conjuntoVar], numberOfClusters)
	return (result)
}

aplicarHClust <- function(data, conjuntoVar= 3:length(data)){
	result<- hclust(dist(data[,conjuntoVar]))
	plot(result)
	return (result)
}