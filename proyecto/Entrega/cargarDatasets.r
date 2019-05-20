#################################################################################
# cargarDatasets.R
#
# Archivo para cargar los datasets en memoria.
#
#################################################################################

cargar <- function(directory){
	# Directorio con los datasets finales limpiados y mezclados.
	directory <- directory

	# Almacenamos los archivos del directorio.
	filesOnDirectory <- list.files(directory)

	# Creamos una lista para los datasets.
	datasets <- list()

	# Para cada archivo en el directorio, 
	for(nameOfFile in filesOnDirectory){
		
		# Obtenemos el nombre del país, quitando los últimos 4 caracteres del nombre del archivo que son
		# siempre ".csv"
		nameOfCountry <- substr(nameOfFile, 1, nchar(nameOfFile)-4)
		fileToRead <- paste(directory,nameOfFile,sep="")

		# Leemos/cargamos el dataset.
		dataset <- read.csv(fileToRead, header = TRUE, sep=",", dec=".",stringsAsFactor=FALSE)

		# Añadimos a la lista el dataset.
		datasets <- c(datasets,list(name=dataset))

		# Ponemos el nombre del dataset.
		names(datasets)[length(datasets)] <- nameOfCountry
	}

	# Si una fila solamente tiene un dato, eliminamos la fila porque no nos va a aportar información, debido a que ese dato será unicamente el año.
	datasets <- lapply(datasets,function(country){
		i<-1
		while (i <= nrow(country)){
			if(sum(is.na(country[i,])) == (length(country)-1)){
				country <- country[-i,]
			}
			else{
				i <- i+1
			}
		}
		 country
	})
	return (datasets)
}