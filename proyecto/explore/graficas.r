#################################################################################
# graficas.r
#
# Archivo con las funciones para generar las gráficas.
#
#################################################################################

getYears <- function(data, years){
	returnData <- rep(FALSE,nrow(data))
	for(i in years){
		returnData <- returnData | data$Year==i
	}
	returnData
}

plotVsMonth <- function(data,var1,years){
	selectRows <- getYears(data,years)
	months <- data$Month[selectRows]
	var <- data[selectRows,var1]
	barplot(var,names.arg=months)
	lines(rep(data[selectRows,grepl(paste("^A",var1,sep=""),colnames(data))],12), col="red")
}

plot2VsMonth <- function(data,var1,var2,years){
	selectRows <- getYears(data,years)
	months <- data$Month[selectRows]
	var <- data[selectRows,var1]
	varp <- data[selectRows,var2]
	var <- rbind(var,varp)
	barplot(var,names.arg=months, beside=TRUE)
	legend("topright", legend=c(var1,var2),fill=c("grey30","grey80"))
}

plotThroughYears <- function(data,var1,years){
	inicio <- 10
	colors <- colors()[seq(inicio,length(years)*6+(inicio-1),by=6)]
	for(i in 1:length(years)){
		plot(1:12,data[data$Year==years[i],var1],col=colors[i],type="l",ylim=c(-5,30))
		par(new=T)
	}
	legend("topleft",as.character(years),fill=colors)
	par(new=FALSE)
}