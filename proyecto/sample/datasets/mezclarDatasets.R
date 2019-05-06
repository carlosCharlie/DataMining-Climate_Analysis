#################################################################################
# mezclarDatasets.R
#
# Archivo para mezclar los datasets de las distintas fuentes de datos en un
# único dataset limpio con la máxima información y listo para procesarlo.
#
#################################################################################

# Rutas de los archivos
directory <- "./sample/datasets/climateKnowledge/"
directoryAfrica <- "./sample/datasets/tuTiempo/africa/"
directoryAntarctica <- "./sample/datasets/tuTiempo/antarctica/"
directoryAsia <- "./sample/datasets/tuTiempo/asia/"
directoryEurope <- "./sample/datasets/tuTiempo/europe/"
directoryNorthAmerica <- "./sample/datasets/tuTiempo/north-america/"
directoryOceania <- "./sample/datasets/tuTiempo/oceania/"
directorySouthAmerica <- "./sample/datasets/tuTiempo/south-america/"

# Guardamos los archivos dentro de los directorios
filesOnDirectory <- list.files(directory)
filesOnAfrica <- list.files(directoryAfrica)
filesOnAntarctica <- list.files(directoryAntarctica)
filesOnAsia <- list.files(directoryAsia)
filesOnEurope <- list.files(directoryEurope)
filesOnNorthAmerica <- list.files(directoryNorthAmerica)
filesOnOceania <- list.files(directoryOceania)
filesOnSouthAmerica <- list.files(directorySouthAmerica)

# Recorremos los archivos del directorio principal de la página climateKnowledge. Para cada archivo, comprobamos
# si está en algunos de los directorios de tuTiempo. En caso afirmativo los leemos y los mezclamos en uno único.
# Finalmente se guarda en un nuevo directorio llamado datasetsFinales.
for(nameOfFile in filesOnDirectory){
	if(is.element(nameOfFile,filesOnAfrica)){
		dataset1 <- read.csv(paste(directory,nameOfFile,sep=""),header=TRUE,sep=",",dec=".",stringsAsFactor=FALSE)
		dataset2 <- read.csv(paste(directoryAfrica,nameOfFile,sep=""),header=TRUE,sep=",",dec=".",stringsAsFactor=FALSE)
		write.csv(merge(dataset1,dataset2,by=c("Year"),all.x=TRUE),file = paste("sample/datasets/datasetsFinales/",nameOfFile,sep=""))
	}
	else if(is.element(nameOfFile,filesOnAntarctica)){
		dataset1 <- read.csv(paste(directory,nameOfFile,sep=""),header=TRUE,sep=",",dec=".",stringsAsFactor=FALSE)
		dataset2 <- read.csv(paste(directoryAntarctica,nameOfFile,sep=""),header=TRUE,sep=",",dec=".",stringsAsFactor=FALSE)
		write.csv(merge(dataset1,dataset2,by=c("Year"),all.x=TRUE),file = paste("sample/datasets/datasetsFinales/",nameOfFile,sep=""))
	}
	else if(is.element(nameOfFile,filesOnAsia)){
		dataset1 <- read.csv(paste(directory,nameOfFile,sep=""),header=TRUE,sep=",",dec=".",stringsAsFactor=FALSE)
		dataset2 <- read.csv(paste(directoryAsia,nameOfFile,sep=""),header=TRUE,sep=",",dec=".",stringsAsFactor=FALSE)
		write.csv(merge(dataset1,dataset2,by=c("Year"),all.x=TRUE),file = paste("sample/datasets/datasetsFinales/",nameOfFile,sep=""))	
	}
	else if(is.element(nameOfFile, filesOnEurope)){
		dataset1 <- read.csv(paste(directory,nameOfFile,sep=""),header=TRUE,sep=",",dec=".",stringsAsFactor=FALSE)
		dataset2 <- read.csv(paste(directoryEurope,nameOfFile,sep=""),header=TRUE,sep=",",dec=".",stringsAsFactor=FALSE)		
		write.csv(merge(dataset1,dataset2,by=c("Year"),all.x=TRUE),file = paste("sample/datasets/datasetsFinales/",nameOfFile,sep=""))
	}
	else if(is.element(nameOfFile,filesOnNorthAmerica)){
		dataset1 <- read.csv(paste(directory,nameOfFile,sep=""),header=TRUE,sep=",",dec=".",stringsAsFactor=FALSE)
		dataset2 <- read.csv(paste(directoryNorthAmerica,nameOfFile,sep=""),header=TRUE,sep=",",dec=".",stringsAsFactor=FALSE)
		merge(dataset1,dataset2,by=c("Year"))
		write.csv(merge(dataset1,dataset2,by=c("Year"),all.x=TRUE),file = paste("sample/datasets/datasetsFinales/",nameOfFile,sep=""))
	}
	else if(is.element(nameOfFile, filesOnOceania)){
		dataset1 <- read.csv(paste(directory,nameOfFile,sep=""),header=TRUE,sep=",",dec=".",stringsAsFactor=FALSE)
		dataset2 <- read.csv(paste(directoryOceania,nameOfFile,sep=""),header=TRUE,sep=",",dec=".",stringsAsFactor=FALSE)
		write.csv(merge(dataset1,dataset2,by=c("Year"),all.x=TRUE),file = paste("sample/datasets/datasetsFinales/",nameOfFile,sep=""))
	}
	else if(is.element(nameOfFile, filesOnSouthAmerica)){
		dataset1 <- read.csv(paste(directory,nameOfFile,sep=""),header=TRUE,sep=",",dec=".",stringsAsFactor=FALSE)
		dataset2 <- read.csv(paste(directorySouthAmerica,nameOfFile,sep=""),header=TRUE,sep=",",dec=".",stringsAsFactor=FALSE)
		write.csv(merge(dataset1,dataset2,by=c("Year"),all.x=TRUE),file = paste("sample/datasets/datasetsFinales/",nameOfFile,sep=""))
	}
}