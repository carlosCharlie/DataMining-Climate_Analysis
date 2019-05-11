agregar <- function(data, agregateNumber, nom){
	monthVar <- c("JanTemperature","FebTemperature","MarTemperature","AprTemperature","MayTemperature","JunTemperature","JulTemperature","AugTemperature","SepTemperature","OctTemperature","NovTemperature","DecTemperature","JanRain","FebRain","MarRain","AprRain","MayRain","JunRain","JulRain","AugRain","SepRain","OctRain","NovRain","DecRain")
	for(i in seq(1,length(monthVar),agregateNumber)){
		mean <- apply(data[monthVar[i:(i+agregateNumber-1)]],1,mean)
		data[monthVar[i]]<-mean
		data[monthVar[(i+1):(i+agregateNumber-1)]]<-NULL
		colnames(data)[colnames(data)==monthVar[i]]<- paste(toString(((i%/%agregateNumber)%%(12/agregateNumber))+1),paste(nom,substr(monthVar[i],4,nchar(monthVar[i])),sep=""),sep="")
	}
	return (data)
}

agregarTrimestres <- function(data){
	aux <- agregar(data,3,"Tri")
	return (aux)
}

agregarCuatrimestres <- function(data){
	aux <- agregar(data,4,"Cuatri")
	return (aux)
}

agregarSemestres <- function(data){
	aux <- agregar(data,6,"Sem")
	return (aux)
}