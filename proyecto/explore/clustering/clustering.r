
source("explore/clustering/cargaParaClustering.R")

data <- loadTraining(14); #esta funcion esta en "cargaParaClustering.R"

temperature<-data$temperatures;
raining<-data$raining;
names<-data$names;

temperatureRain <- matrix(c(temperature,raining),ncol=2); #Una columna para las temperaturas y otra para las lluvias.
result <- kmeans(temperatureRain,5)

#para dibujar
plot(temperatureRain,col=result$cluster)

for(i in 1:(length(temperature)))
    print(paste("el clima de ",gsub("-"," ",gsub("^([a-z,A-Z,-]*/)*|.csv","",data$names[i])),"es de tipo",result$cluster[i]))