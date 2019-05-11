#################################################################################
# graficas.r
#
# Archivo con las funciones para generar las gráficas.
#
#################################################################################
months <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")

getYears <- function(data, years){
	returnData <- rep(FALSE,nrow(data))
	for(i in years){
		returnData <- returnData | data$Year==i
	}
	return (returnData)
}

plotVsMonth <- function(data,var1,years){
	selectRows <- getYears(data,years)
	variable <- data[selectRows,grepl(paste("^[A-Z,a-z]{3}",var1,sep=""),colnames(data))]
	variable <- unlist(variable,use.names=FALSE)
	barplot(variable,names.arg=months, ylim=c(-15,30))
}

plotVsMonthWithMean <- function(data,var1,years){
	selectRows <- getYears(data,years)
	variable <- data[selectRows,grepl(paste("^[A-Z,a-z]{3}",var1,sep=""),colnames(data))]
	variable <- unlist(variable,use.names=FALSE)
	barplot(variable,names.arg=months, ylim=c(-15,30))
	lines(rep(data[selectRows,grepl(paste("^A",var1,sep=""),colnames(data))],12), col="red")
}

plot2VsMonth <- function(data,var1,var2,years){
	selectRows <- getYears(data,years)
	variable <- data[selectRows,grepl(paste("^[A-Z,a-z]{3}",var1,sep=""),colnames(data))]
	varp <- data[selectRows,grepl(paste("^[A-Z,a-z]{3}",var2,sep=""),colnames(data))]
	variable <- unlist(variable,use.names=FALSE)
	varp <- unlist(varp,use.names=FALSE)
	variable <- rbind(variable,varp)
	barplot(variable,names.arg=months, beside=TRUE, col=c("grey30","grey80"))
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