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

#Para modificar la estructura de los datos. Dado que cada ejemplo tiene datos de un unico mes, creamos 12 columnas para la temperatura
#y 12 para la lluvia, de forma que cada ejemplo contenga información de todos los meses del año de forma conjunta.
#Para conseguir eso, se recorren los años y se generan dos matrices, en las que cada una de sus filas contendran las temperaturas y lluvias de un único año;
#obteniendo asi tantas filas como años contempla del dataset.
#Finalmente se concatenan dichas matrices a un dataframe formado por las variables Years y Country.
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

#Exiten varias columnas que contienen muchos valores NA y para no perder muchos datos se eliminan.
#Para ello reducimos el dataframe a las primeras 5 columnas.
limpiarTuTiempo <- function(data){
	data<-data[1:5]
 	colnames(data) <- c("Year","ATemperature","AMaxTemperature","AMinTemperature","APrecipitation")
 	return (data)
}

# Función que cambia los nombres de las columnas a unos preestablecidos o dados por parámetro.
cambiarNombresVariables <- function(data, names=c("Year","Country","JanTemperature","FebTemperature","MarTemperature","AprTemperature","MayTemperature","JunTemperature","JulTemperature","AugTemperature","SepTemperature","OctTemperature","NovTemperature","DecTemperature","JanRain","FebRain","MarRain","AprRain","MayRain","JunRain","JulRain","AugRain","SepRain","OctRain","NovRain","DecRain","ATemperature","AMaxTemperature","AMinTemperature","APrecipitation")){
	colnames(data) <- names
	return (data)
}

# Funcion para calcular la temperatura media anual en caso de que no la proporcione el dataset y sea un NA
calcularMediasAnuales <- function(data){
	for(i in 1:nrow(data)){
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
			acumulatedPrecipitation <- mean(unlist(data[i,c("JanRain","FebRain","MarRain","AprRain","MayRain","JunRain","JulRain","AugRain","SepRain","OctRain","NovRain","DecRain")],use.names=FALSE))
			data[i,"APrecipitation"] <- acumulatedPrecipitation
	}
	return (data)
}

# Normalizamos los datos para que no alteren los resultados de las gráficas, ya que los números de las precipitaciones
# son mucho mayores que los de temperatura. Para la normalización se utiliza la función Z-Score y se calcula obteniendo medias y desviacion
# de cada variable y normalizando todos los ejemplos restando la media y dividiendo entre la desviacion
normalizarANormal <- function(data, varToNormalize=c("JanTemperature","FebTemperature","MarTemperature","AprTemperature","MayTemperature","JunTemperature","JulTemperature","AugTemperature","SepTemperature","OctTemperature","NovTemperature","DecTemperature","JanRain","FebRain","MarRain","AprRain","MayRain","JunRain","JulRain","AugRain","SepRain","OctRain","NovRain","DecRain","ATemperature","AMaxTemperature","AMinTemperature","APrecipitation")){
	means <- vector()
	stds <- vector()
	for(i in varToNormalize){
		totalSum <- sum(data[,i],na.rm=TRUE)
	 	howMany <- sum(!is.na(data[,i]))
		mean <- totalSum/howMany
		squareSum <- sum(((mean-data[,i])^2),na.rm=TRUE)
		std <- sqrt(squareSum/howMany)
		data[,i] <- (data[,i]-mean)/std
		means <- cbind(means,mean)
		stds <- cbind(stds,std)
	}
	colnames(means)<-varToNormalize
	colnames(stds)<-varToNormalize
	return (list(data,means,stds))
}

#Funcion para desnormalizar un conjunto de datos dada una media y una desviacion, para ello se aplica la formula inversa a la
#que se utiliza para normalizar. Importante solo aplicarlo en las columnas que estan normalizadas, por ello se recorre
#el conjunto de nombres del array que contiene las medias
desnormalizar <- function(data, mean, std){
	for(i in colnames(mean)){
		data[i]<-data[i]*std[,i]+mean[,i]
	}
	return (data)
}


