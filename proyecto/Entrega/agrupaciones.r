#Dado que se dispone de información mensual, se considera apropiado probar a agregar dicha información en distintas duraciones
#Como trimestrales y semestrales. Para ello se define una funcion que dados unos datos, un numero de meses en un grupo y un nombre para las nuevas variables
#agrega los datos de la forma adecuada.
#Para ello, se recorre el array de variables mensuales, utilizando una secuencia cuya razón es del numero de meses dentro de un grupo
#de esta forma se pueden acceder a las variables que formarían cada grupo y agregar sus datos mediante la media.
#Finalmente el primero de los meses del grupo se sustituye por la nueva agregación calculada, y el resto de meses se eliminan
agregar <- function(data, agregateNumber, nom, monthVar=c("JanTemperature","FebTemperature","MarTemperature","AprTemperature","MayTemperature","JunTemperature","JulTemperature","AugTemperature","SepTemperature","OctTemperature","NovTemperature","DecTemperature","JanRain","FebRain","MarRain","AprRain","MayRain","JunRain","JulRain","AugRain","SepRain","OctRain","NovRain","DecRain")){
	for(i in seq(1,length(monthVar),agregateNumber)){
		mean <- apply(data[monthVar[i:(i+agregateNumber-1)]],1,mean)
		data[monthVar[i]]<-mean
		data[monthVar[(i+1):(i+agregateNumber-1)]]<-NULL
		colnames(data)[colnames(data)==monthVar[i]]<- paste(toString(((i%/%agregateNumber)%%(12/agregateNumber))+1),paste(nom,substr(monthVar[i],4,nchar(monthVar[i])),sep=""),sep="")
	}
	return (data)
}

#Con la función definida e implementada anteriormente genera un nuevo dataset con los datos agregados por trimestres
agregarTrimestres <- function(data){
	aux <- agregar(data,3,"Tri")
	return (aux)
}

#Con la función definida e implementada anteriormente genera un nuevo dataset con los datos agregados por semestres
agregarSemestres <- function(data){
	aux <- agregar(data,6,"Sem",c("JanTemperature","FebTemperature","MarTemperature","OctTemperature","NovTemperature","DecTemperature","AprTemperature","MayTemperature","JunTemperature","JulTemperature","AugTemperature","SepTemperature","JanRain","FebRain","MarRain","OctRain","NovRain","DecRain","AprRain","MayRain","JunRain","JulRain","AugRain","SepRain"))
	colnames(aux)[colnames(aux)=="1SemTemperature"] <- "ColdMonthsT"
	colnames(aux)[colnames(aux)=="2SemTemperature"] <- "HotMonthsT"
	colnames(aux)[colnames(aux)=="1SemRain"] <- "ColdMonthsR"
	colnames(aux)[colnames(aux)=="2SemRain"] <- "HotMonthsR"
	return (aux)
}