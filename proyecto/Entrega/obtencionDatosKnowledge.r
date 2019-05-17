#################################################################################
# ObtencionDatosKnowledge.R
#
# Archivo que realiza la coexión con la página web ClimateKnowledge y obtiene los
# datasets.
#
#################################################################################
rm(list=ls())
if(!require("RCurl")){
	install.packages("RCurl")
	require("RCurl")
}

#Con esta funcion se transforman los datos para meterlo en un dataframe, ya que se encuentran en una linea de caracteres.
#Para ello se separan las lineas por saltos de linea, y despues por comas. Tras esto se crea una matriz con 5 columnas que es
#el numero de variables que contiene cada dataset. Y la primera fila de la matriz seran los nombres de las variables 
toDataFrame <- function(data){
	  data<-strsplit(data,"\n")
  	data<-lapply(data,function(x){strsplit(x,", ")})
  	futureMatrix <- unlist(data)
  	newMatrix <- matrix(futureMatrix, nrow=length(futureMatrix)/5,ncol=5,T)
  	df <- data.frame(newMatrix[2:nrow(newMatrix),], stringAsFactors=FALSE)
  	names(df) <- newMatrix[1,]
  	df
}

countries <- read.delim2("names.txt",sep="\t",header = FALSE);

#Se recorren los paises que se encuentran en el archivo names.txt para acceder a la url adecuada
for(i in 1:(length(countries[,1]))){
  
  url <- paste("https://climateknowledgeportal.worldbank.org/api/data/get-download-data/historical/tas/1901-2016/",toupper(substr(countries[i,1],1,3)),"/",countries[i,1],sep="");
  tmp <- getURL(url);

  #Se comprueba que los datos devueltos tienen datos, por ello es necesario comprobrar que existe el nombre de las variables y algo más
  if(nchar(tmp)>nchar("Temperature - (Celsius), Year, Month, Country, ISO3\n") && !grepl("<html>",tmp)){
    
  	df1 <- toDataFrame(tmp)
    #Se repite la llamada a la url pero esta vez con los datos de lluvia y se vuelve a comprobar si la url contiene datos
  	url <- paste("https://climateknowledgeportal.worldbank.org/api/data/get-download-data/historical/pr/1901-2016/",toupper(substr(countries[i,1],1,3)),"/",countries[i,1],sep="");
  	tmp <- getURL(url);
  	if(nchar(tmp)>nchar("Rainfall - (MM), Year, Month, Country, ISO3\n") && !grepl("<html>",tmp)){
  		df2 <- toDataFrame(tmp)
		  #Si ambas llamadas devuelven datos, se procede a mezclar ambos utilizando las 4 columnas comunes
  		tmp <- merge(df1,df2,by=c("Year","Country","Month","ISO3"))
      #Al mezclar los datos se genera una columna basura que se procede a eliminar y se renombran las variables
		  tmp <- tmp[c(1,2,3,4,5,7)]
		  colnames(tmp) <- c("Year","Country","Month","ISO3","Temperature","Rain")
      #Los meses no se encuentran ordenados cronologicamente, y para ordenarlos se realiza una ordenación "manual" ya que siempre
      #se encuentran en las mismas posiciones
      for(year in unique(tmp$Year)){
        littleSet <- tmp[tmp$Year==year,]
        orderSet <- littleSet[5,]
        orderSet <- rbind(orderSet, littleSet[4,])
        orderSet <- rbind(orderSet, littleSet[8,])
        orderSet <- rbind(orderSet, littleSet[1,])
        orderSet <- rbind(orderSet, littleSet[9,])
        orderSet <- rbind(orderSet, littleSet[7,])
        orderSet <- rbind(orderSet, littleSet[6,])
        orderSet <- rbind(orderSet, littleSet[2,])
        orderSet <- rbind(orderSet, littleSet[12,])
        orderSet <- rbind(orderSet, littleSet[11,])
        orderSet <- rbind(orderSet, littleSet[10,])
        orderSet <- rbind(orderSet, littleSet[3,])
        tmp[tmp$Year==year,] <- orderSet
      }
      #Finalmente se guarda el dataset
  	 	write.csv(tmp, file = paste("datasets/climateKnowledge/",tolower(gsub(" ","-",countries[i,1])),".csv",sep=""), row.names=FALSE);
  	}
  }
}