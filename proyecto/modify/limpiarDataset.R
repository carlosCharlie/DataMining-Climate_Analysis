#################################################################################
# limpiarDataset.R
#
# Archivo con las funciones necesarias para la etapa de Modify, es decir, para
# limpiar los datasets y dejar los campos libres de NA y preparados para el 
# posterior procesamiento.
#
#################################################################################


# Función que elimina los NA del dataset. Recorremos todas las filas del dataset una a una y 
# si existe alguna columna con un NA, eliminamos la fila. Después recalculamos los indices
# por las filas borradas.
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


# Función que cambia los nombres de las columnas a unos preestablecidos.
cambiarNombresVariables <- function(data, names=c("Year","Country","Month","Temperature","Rain","ATemperature","AMaxTemperature","AMinTemperature","TotalPrecipitation","AWindSpeed","RainDays","SnowDays","StormDays","FoggyDays","TornadoDays","HailDays")){
	colnames(data) <- names
	return (data)
}

# Funcion para calcular la temperatura media anual en caso de que no la proporcione el dataset y sea un NA
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

# Función para calcular la temperatura máxima anual en caso de que no la proporcione el dataset y sea un NA
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

# Función para calcular la temperatura mínima anual en caso de que no la proporcione el dataset y sea un NA
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

# Función para calcular las precipitaciones anuales en caso de que no la proporcione el dataset y sea un NA
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

normalizarANormal <- function(data, , varToNormalize=c("Temperature","Rain","ATemperature","AMaxTemperature","AMinTemperature","TotalPrecipitation","AWindSpeed","RainDays","SnowDays","StormDays","FoggyDays","TornadoDays","HailDays")){
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