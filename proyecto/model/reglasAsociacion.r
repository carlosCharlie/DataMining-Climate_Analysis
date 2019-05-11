if(!require(arules)){
	install.packages("arules",dependencies=TRUE)
}
require(arules)

gc()

discretizarCo0umnasEnteras <- function(data,cuantosIntervalos=5){
	data$Year <- as.factor(data$Year)
	varNoDiscretize <- unlist(lapply(data,is.factor),use.names=FALSE) | unlist(lapply(data,is.logical),use.names=FALSE) | colnames(data)=="Year"
 	data[!varNoDiscretize] <- lapply(data[!varNoDiscretize],function(x){discretize(x,method="interval",breaks=(abs(min(x))+abs(max(x)))/cuantosIntervalos)})
 	return (data)
}

calcularReglas <- function(data){
	results<-apriori(data)
	return (results)
}