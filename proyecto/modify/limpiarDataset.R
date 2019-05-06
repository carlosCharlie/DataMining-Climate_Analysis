eliminarNAs <- function(data){
	i<-0
	while(i<nrow(data)){
		if(any(is.na(data[i,]))){
			data <- data[-i,]
		}
		else i<-i+1
	}
	rownames(data) <- seq(length=nrow(data))
	return (data)
}

cambiarNombresVariables <- function(data, names=c("Year","Country","Month","Temperature","Rain","ATemperature","AMaxTemperature","AMinTemperature","TotalPrecipitation","AWindSpeed","RainDays","SnowDays","StormDays","FoggyDays","TornadoDays","HailDays")){
	colnames(data) <- names
	return (data)
}

calcularMediasAnuales <- function(data){
	for(i in unique(data$Year)){
		aux <- data[i==data$Year,]
		if(any(is.na(aux$ATemperature))){
			media <- mean(aux$Temperature)
			data[i==data$Year,"ATemperature"] <- media
		}
	}
	return (data)
}

calcularMaxAnuales <- function(data){
	for(i in unique(data$Year)){
		aux <- data[i==data$Year,]
		if(any(is.na(aux$AMaxTemperature))){
			max <- max(aux$Temperature)
			data[i==data$Year,"AMaxTemperature"] <- max
		}
	}
	return (data)
}

calcularMinAnuales <- function(data){
	for(i in unique(data$Year)){
		aux <- data[i==data$Year,]
		if(any(is.na(aux$AMinTemperature))){
			min <- min(aux$Temperature)
			data[i==data$Year,"AMinTemperature"] <- min
		}
	}
	return (data)
}

calcularPrecipitacionesAnuales <- function(data){
	for(i in unique(data$Year)){
		aux <- data[i==data$Year,]
		if(any(is.na(aux$TotalPrecipitation))){
			acumulatedPrecipitation <- sum(aux$Rain)
			data[i==data$Year,"TotalPrecipitation"] <- acumulatedPrecipitation
		}
	}
	return (data)
}

normalizarMinMax <- function(data, varToNormalize=c("Temperature","Rain","ATemperature","AMaxTemperature","AMinTemperature","TotalPrecipitation","AWindSpeed","RainDays","SnowDays","StormDays","FoggyDays","TornadoDays","HailDays")){
	if(!require("scales")){
		install.packages("scales")
		require("scales")
	}
	for(i in varToNormalize){
		min <- min(unlist(lapply(data,function(x){min(x[,i],na.rm=TRUE)}), use.names=FALSE))
	 	max <- max(unlist(lapply(data,function(x){max(x[,i],na.rm=TRUE)}), use.names=FALSE))
		for(x in 1:length(data)){
			data[[x]][,i] <- rescale(data[[x]][,i], from=c(min,max))
		}
	}
	return (data)
}

normalizarANormal <- function(data, varToNormalize=c("Temperature","Rain","ATemperature","AMaxTemperature","AMinTemperature","TotalPrecipitation","AWindSpeed","RainDays","SnowDays","StormDays","FoggyDays","TornadoDays","HailDays")){
	for(i in varToNormalize){
		totalSum <- sum(unlist(lapply(data,function(x){sum(x[,i],na.rm=TRUE)}), use.names=FALSE))
	 	howMany <- sum(unlist(lapply(data,function(x){sum(!is.na(x[,i]))}), use.names=FALSE))
		mean <- totalSum/howMany
		squareSum <- sum(unlist(lapply(data,function(x){(mean-x[,i])^2})))
		std <- sqrt(squareSum/howMany)
		for(x in 1:length(data)){
			data[[x]][,i] <- (data[[x]][,i]-mean)/std
		}
	}
	return (data)
}