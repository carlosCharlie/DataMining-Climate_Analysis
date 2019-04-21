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