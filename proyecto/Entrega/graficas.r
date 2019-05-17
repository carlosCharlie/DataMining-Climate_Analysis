#################################################################################
# graficas.r
#
# Archivo con las funciones para generar las gráficas.
#
#################################################################################

#Funcion que dado un conjunto de años devuelve todas las filas cuyo año esta contenido en dicho conjunto
getYears <- function(data, years){
	returnData <- rep(FALSE,nrow(data))
	for(i in years){
		returnData <- returnData | data$Year==i
	}
	returnData
}

#Dada una variable printa sus valores en un grafico de barras teniendo a los meses en el eje x.
#Ademas se añade una linea roja que representa la media de la variable en ese año
plotVsMonth <- function(data,var1,years){
	selectRows <- getYears(data,years)
	months <- data$Month[selectRows]
	var <- data[selectRows,var1]
	barplot(var,names.arg=months)
	lines(rep(data[selectRows,grepl(paste("^A",var1,sep=""),colnames(data))],12), col="red")
}

#Dada dos variables printa ambas en un grafico de barras teniendo a los meses en el eje x.
#Cada mes tendrá dos barras que representaran las variables, para distinguirlas se añade la leyenda arriba a la derecha de la gráfica
plot2VsMonth <- function(data,var1,var2,years){
	selectRows <- getYears(data,years)
	months <- data$Month[selectRows]
	var <- data[selectRows,var1]
	varp <- data[selectRows,var2]
	var <- rbind(var,varp)
	barplot(var,names.arg=months, beside=TRUE)
	legend("topright", legend=c(var1,var2),fill=c("grey30","grey80"))
}