
source("cargarDatasets.r");
source("modify/limpiarDataset.r")

loadTraining <- function(n){
  
  filled <- lapply(datasets,function(x){calcularMediasAnuales(calcularMaxAnuales(calcularMinAnuales(x)))});
  resultNorm <- normalizarANormal(filled);
  normalized <- resultNorm[[1]];
  
  temperatures = vector();
  raining = vector();
  names = vector();
  
  for(country in normalized){
      temperatures <- c(temperatures,mean(country$ATemperature));
      
      #Uno todas las columnas de lluvias en un solo vector para tener todas las lluvias del año
      rainTmp <- vector();
      for(month in (country[grep("[A-Za-z]*Rain",colnames(country), perl=TRUE, value=TRUE)]))
        rainTmp <- c(rainTmp,month);
      
      raining <- c(raining,mean(rainTmp));
      names <-(c(names,country$Country[1]));
  }
  
  result <- data.frame(temperatures = temperatures, raining = raining, names = names);

  gc(full="TRUE")
  
  result
}