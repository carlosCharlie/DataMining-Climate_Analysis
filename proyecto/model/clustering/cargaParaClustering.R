#################################################################################
# cargaParaClustering.r
#
# 
#
#################################################################################

loadTraining <- function(nFiles){
  
  count <- 1;
  list <- vector();
  
  # Cargo los paises por continentes ( lista de continentes donde cada elemento es a su vez una lista con los paises de ese continente)
  continents <- lapply(list.dirs(path="sample/datasets/tuTiempo"),function(continent){list.files(path=continent,full.names = TRUE)});
  
  #Cojo un pais por continente en cada vuelta de bucle hasta llegar a nFiles paises
  #De esta forma me aseguro de que hay mas diferencia entre los climas
  while(count<nFiles){
    
    for(i in 2:length(continents))
      list = c(list,continents[[i]][count]);
    
    count=count+length(continents);
  }
  
  temperatures = vector();
  raining = vector();
  names = vector();
  
  #Calculo las medias de temperaturas y lluvias para cada pais seleccionado
  for(country in list){
    names <- c(names,country);
    temperatures <- c(temperatures,mean(as.double(na.omit(read.csv2(stringsAsFactors = FALSE,country,header = TRUE, sep = ",")$ATemperature))));
    raining <- c(raining,mean(as.double(na.omit(read.csv2(stringsAsFactors = FALSE,country,header = TRUE, sep = ",")$RainDays))));
  }
  
  result <- data.frame(temperatures = temperatures, raining = raining, names = names);
  result;
}