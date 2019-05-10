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

limpiarClimateKnowledge <- function(data){
	matrizTemperatura <- vector()
    matrizLluvia <- vector()
      for(year in unique(data$Year)){
        littleSet <- data[data$Year==year,]
        arrayTemperature <- as.numeric(as.character(littleSet$Temperature))
		arrayRain <- as.numeric(as.character(littleSet$Rain)) 
		matrizTemperatura <- rbind(matrizTemperatura,arrayTemperature)
		matrizLluvia <- rbind(matrizLluvia,arrayRain)
      }
	data <- unique(data[1:2])
	data <- cbind(data,matrizTemperatura)
	data <- cbind(data,matrizLluvia)
	colnames(data) <- c("Year","Country","JanTemperature","FebTemperature","MarTemperature","AprTemperature","MayTemperature","JunTemperature","JulTemperature","AugTemperature","SepTemperature","OctTemperature","NovTemperature","DecTemperature","JanRain","FebRain","MarRain","AprRain","MayRain","JunRain","JulRain","AugRain","SepRain","OctRain","NovRain","DecRain")
	return (data)
}

limpiarTuTiempo <- function(data){
	data<-data[1:5]
 	colnames(data) <- c("Year","ATemperature","AMaxTemperature","AMinTemperature","TotalPrecipitation")
 	return (data)
}

# Función que cambia los nombres de las columnas a unos preestablecidos.
cambiarNombresVariables <- function(data, names=c("Year","Country","JanTemperature","FebTemperature","MarTemperature","AprTemperature","MayTemperature","JunTemperature","JulTemperature","AugTemperature","SepTemperature","OctTemperature","NovTemperature","DecTemperature","JanRain","FebRain","MarRain","AprRain","MayRain","JunRain","JulRain","AugRain","SepRain","OctRain","NovRain","DecRain","ATemperature","AMaxTemperature","AMinTemperature","TotalPrecipitation")){
	colnames(data) <- names
	return (data)
}

# Funcion para calcular la temperatura media anual en caso de que no la proporcione el dataset y sea un NA
calcularMediasAnuales <- function(data){
	for(i in 1:nrow(data)){
		print(data[i,"ATemperature"])
		if(is.na(data[i,"ATemperature"])){
			media <- mean(unlist(data[i,c("JanTemperature","FebTemperature","MarTemperature","AprTemperature","MayTemperature","JunTemperature","JulTemperature","AugTemperature","SepTemperature","OctTemperature","NovTemperature","DecTemperature")],use.names=FALSE))
			data[i,"ATemperature"] <- media
		}
	}
	return (data)
}

# Función para calcular la temperatura máxima anual en caso de que no la proporcione el dataset y sea un NA
calcularMaxAnuales <- function(data){
	for(i in 1:nrow(data)){
		if(is.na(data[i,"AMaxTemperature"])){
			max <- max(data[i,c("JanTemperature","FebTemperature","MarTemperature","AprTemperature","MayTemperature","JunTemperature","JulTemperature","AugTemperature","SepTemperature","OctTemperature","NovTemperature","DecTemperature")])
			data[i,"AMaxTemperature"] <- max
		}
	}
	return (data)
}

# Función para calcular la temperatura mínima anual en caso de que no la proporcione el dataset y sea un NA
calcularMinAnuales <- function(data){
	for(i in 1:nrow(data)){
		if(is.na(data[i,"AMinTemperature"])){
			min <-  min(data[i,c("JanTemperature","FebTemperature","MarTemperature","AprTemperature","MayTemperature","JunTemperature","JulTemperature","AugTemperature","SepTemperature","OctTemperature","NovTemperature","DecTemperature")])
			data[i,"AMinTemperature"] <- min
		}
	}
	return (data)
}

# Función para calcular las precipitaciones anuales en caso de que no la proporcione el dataset y sea un NA
calcularPrecipitacionesAnuales <- function(data){
	for(i in 1:nrow(data)){
		if(is.na(data[i,"TotalPrecipitation"])){
			acumulatedPrecipitation <- sum(data[i,c("JanRain","FebRain","MarRain","AprRain","MayRain","JunRain","JulRain","AugRain","SepRain","OctRain","NovRain","DecRain")])
			data[i,"TotalPrecipitation"] <- acumulatedPrecipitation
		}
	}
	return (data)
}

# Normalizamos los datos para que no alteren los resultados de las gráficas, ya que los números de las precipitaciones
# son mucho mayores que los de temperatura. Cogemos el mayor valor registrado y lo asignamos al limite superior de la
# normalización, y de forma análoga con el menor valor registrado.
normalizarMinMax <- function(data, varToNormalize=c("JanTemperature","FebTemperature","MarTemperature","AprTemperature","MayTemperature","JunTemperature","JulTemperature","AugTemperature","SepTemperature","OctTemperature","NovTemperature","DecTemperature","JanRain","FebRain","MarRain","AprRain","MayRain","JunRain","JulRain","AugRain","SepRain","OctRain","NovRain","DecRain","ATemperature","AMaxTemperature","AMinTemperature","TotalPrecipitation")){
	if(!require("scales")){
		install.packages("scales")
		require("scales")
	}
	if(!is.list(data) || is.data.frame(data)){
		data <- list(data)
	}
	minimos <- vector()
	maximos <- vector()
	for(i in varToNormalize){
		min <- min(unlist(lapply(data,function(x){min(x[,i],na.rm=TRUE)}), use.names=FALSE))
	 	max <- max(unlist(lapply(data,function(x){max(x[,i],na.rm=TRUE)}), use.names=FALSE))
		for(x in 1:length(data)){
			data[[x]][,i] <- rescale(data[[x]][,i], from=c(min,max))
		}
		minimos <- cbind(minimos,min)
		maximos <- cbind(maximos,max)
	}
	
	return (list(data,minimos,maximos)) 
}

normalizarANormal <- function(data, varToNormalize=c("JanTemperature","FebTemperature","MarTemperature","AprTemperature","MayTemperature","JunTemperature","JulTemperature","AugTemperature","SepTemperature","OctTemperature","NovTemperature","DecTemperature","JanRain","FebRain","MarRain","AprRain","MayRain","JunRain","JulRain","AugRain","SepRain","OctRain","NovRain","DecRain","ATemperature","AMaxTemperature","AMinTemperature","TotalPrecipitation")){
	medias <- vector()
	desviaciones <- vector()
	if(!is.list(data) || is.data.frame(data)){
		data <- list(data)
	}
	for(i in varToNormalize){
		totalSum <- sum(unlist(lapply(data,function(x){sum(x[,i],na.rm=TRUE)}), use.names=FALSE))
	 	howMany <- sum(unlist(lapply(data,function(x){sum(!is.na(x[,i]))}), use.names=FALSE))
		mean <- totalSum/howMany
		squareSum <- sum(unlist(lapply(data,function(x){(mean-x[,i])^2})),na.rm=TRUE)
		std <- sqrt(squareSum/howMany)
		for(x in 1:length(data)){
			data[[x]][,i] <- (data[[x]][,i]-mean)/std
		}
		medias <- cbind(medias,mean)
		desviaciones <- cbind(desviaciones,std)
	}
	return (list(data,medias,desviaciones))
}