
source("sample/datasets/cargarDatasets.R");
source("modify/limpiarDataset.R")

loadTraining <- function(n){
  
  #Selecciono de forma aleatoria los paises de prueba
  filled <- calcularMediasAnuales(calcularMaxAnuales(calcularMinAnuales(datasets)));
  normalized <- normalizarANormal(filled);
  
  temperatures = vector();
  raining = vector();
  names = vector();
  
  for(country in normalized){
      temperatures <- c(temperatures,mean(country$ATemperature));
      raining <- c(raining,mean(country$Rain));
      names <-(c(names,country$Country[1]))
  }
  
  result <- data.frame(temperatures = temperatures, raining = raining, names = names);

  gc(full="TRUE")
  
  result
}