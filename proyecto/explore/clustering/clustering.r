
#Ejecutar hasta que salga un grafico con los grupos bien diferenciados
source("explore/clustering/cargaFinalClustering.r")

data <- loadTraining(30); #esta funcion esta en "cargaParaClustering.R"

temperature<-data$temperatures;
raining<-data$raining;
names<-data$names;

temperatureRain <- matrix(c(temperature,raining),ncol=2); #Una columna para las temperaturas y otra para las lluvias.

#clustering jerarquico para ver cuantos grupos tiene sentido hacer
plot(hclust(dist(temperatureRain)))

result <- kmeans(temperatureRain,4)

#para dibujar
plot(temperatureRain,col=result$cluster)

for(i in 1:(length(temperature)))
    print(paste("el clima de ",gsub("-"," ",gsub("^([a-z,A-Z,-]*/)*|.csv","",data$names[i])),"es de tipo",result$cluster[i]))
