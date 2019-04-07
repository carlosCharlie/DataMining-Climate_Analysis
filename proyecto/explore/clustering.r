
data <- loadTraining(10);

temperature<-data$temperatures;  #cambiar por un vector de TODAS las temperaturas
raining<-data$raining;       #cambiar por un vector de TODAS las lluvias
names<-data$names;

temperatureRain <- matrix(c(temperature,raining),ncol=2); #Una columna para las temperaturas y otra para las lluvias.
result <- kmeans(temperatureRain,8)

#para dibujar
plot(temperatureRain,col=result$cluster)

for(i in 1:(length(temperature)))
    print(paste("el clima de ",gsub("-"," ",gsub("^([a-z,A-Z,-]*/)*|.csv","",data$names[i])),"es de tipo",result$cluster[i]))


loadTraining <- function(nFiles){
  
  count <- 1;
  list <- vector();
  
  continents <- lapply(list.dirs(path="sample/datasets/tuTiempo"),function(continent){list.files(path=continent,full.names = TRUE)});
 
  while(count<nFiles){
     
  for(i in 2:length(continents))
    list = c(list,continents[[i]][count]);
  
  count=count+length(continents);
  }
  
  temperatures = vector();
  raining = vector();
  names = vector();
  
  for(country in list){
    names <- c(names,country);
    temperatures <- c(temperatures,mean(as.double(na.omit(read.csv2(country,header = TRUE, sep = ",")$ATemperature))));
    raining <- c(raining,mean(as.double(na.omit(read.csv2(country,header = TRUE, sep = ",")$RainDays))));
  }
  
  result <- data.frame(temperatures = temperatures, raining = raining, names = names);
  result;
}