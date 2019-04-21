
loadTraining <-function(n){
  #Selecciono de forma aleatoria los paises de prueba
  countries <- list.files(path="sample/datasets/datasetsFinales",full.names = TRUE)
  countries <- countries[sample.int(length(countries),size = n)]
  
  temperatures = vector();
  raining = vector();
  
  #Calculo las medias de temperaturas y lluvias para cada pais seleccionado
  for(country in countries){
    temperatures <- c(temperatures,mean(as.double(na.omit(read.csv2(stringsAsFactors = FALSE,country,header = TRUE, sep = ",")$Temperature....Celsius.))));
    raining <- c(raining,mean(as.double(na.omit(read.csv2(stringsAsFactors = FALSE,country,header = TRUE, sep = ",")$Rainfall....MM.))));
  }
  
  result <- data.frame(temperatures = temperatures, raining = raining, names = countries);
  result;
}