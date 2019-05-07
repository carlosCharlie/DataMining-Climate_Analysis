
source("sample/datasets/cargarDatasets.R");
source("modify/limpiarDataset.R")

loadTraining <- function(n){
  
  filled <- lapply(datasets,function(x){calcularMediasAnuales(calcularMaxAnuales(calcularMinAnuales(x)))});
  resultNorm <- normalizarANormal(filled);
  normalized <- resultNorm[[1]];
  
  temperatures = vector();
  raining = vector();
  names = vector();
  
  coldMonthsT = vector();
  hotMonthsT = vector();
  
  coldMonthsR = vector();
  hotMonthsR = vector();
  
  for(country in normalized){
      
      coldMonthsT <- c(coldMonthsT,mean(c(country$JanTemperature,country$FebTemperature,country$MarTemperature,country$OctTemperature,country$NovTemperature,country$DecTemperature)))
      hotMonthsT <- c(hotMonthsT,mean(c(country$AprTemperature,country$MayTemperature,country$JunTemperature,country$JulTemperature,country$AugTemperature,country$SepTemperature)))
 
      coldMonthsR <- c(coldMonthsR,mean(c(country$JanRain,country$FebRain,country$MarRain,country$OctRain,country$NovRain,country$DecRain)))
      hotMonthsR <- c(hotMonthsR,mean(c(country$AprRain,country$MayRain,country$JunRain,country$JulRain,country$AugRain,country$SepRain)))
      
      temperatures <- c(temperatures,mean(na.omit(country$ATemperature)));
      #Uno todas las columnas de lluvias en un solo vector para tener todas las lluvias del año
      rainTmp <- vector();
      for(month in (country[grep("[A-Za-z]*Rain",colnames(country), perl=TRUE, value=TRUE)]))
        rainTmp <- c(rainTmp,month);
      
      raining <- c(raining,mean(rainTmp));
      names <-(c(names,country$Country[1]))
  }
  
  result <- data.frame(coldMonthsT = coldMonthsT, hotMonthsT = hotMonthsT,coldMonthsR = coldMonthsR, hotMonthsR = hotMonthsR,temperatures = temperatures, raining = raining, names = names);

  gc(full="TRUE")
  
  result
}