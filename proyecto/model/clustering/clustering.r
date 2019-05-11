#################################################################################
# clustering.r
#
# Archivo para realizar el clustering, determinando cuántos clusters tiene
# sentido diferenciar según los datos de los climas de los países.
#
#################################################################################

rm(list=ls())
# Ejecutar todo el script hasta que salga un grafico con los grupos bien diferenciados
source("model/clustering/cargaNormalizada.r")

# Esta función esta en cargaFinalClustering.r
data <- loadTraining(100)

temperature<-data$temperatures;
raining<-data$raining;
names<-data$names;

rm(data)
rm(dataset)
rm(datasets)

temperatureRain <- matrix(c(temperature,raining),ncol=2); #Una columna para las temperaturas y otra para las lluvias.

# Clustering jerárquico para ver cuantos grupos tiene sentido hacer
plot(hclust(dist(temperatureRain)))

result <- kmeans(temperatureRain,4)

# Para dibujar
plot(temperatureRain,col=result$cluster)


predictClimate <- function(temperature,raining){
  
  if(!require("clue"))
    install.packages("clue");
  require("clue");
  
  clue::cl_predict(result,matrix(c(temperature,raining),ncol=2));
}

# Elegimos países que tienen un tipo de clima claramente diferenciado y los utilizamos para agrupar los demás.

i<-1;
clusters<-0;
climateNames <- vector(mode = "character",length = 4);

while(i<length(names) && length(climateNames[unlist(lapply(climateNames,function(x){is.na(x)||x==""}))])>0){
  
  if(names[[i]]=="Panama")climateNames[predictClimate(temperature[i],raining[i])] = "tropical";
  if(names[[i]]=="Saudi Arabia")climateNames[predictClimate(temperature[i],raining[i])] = "seco";
  if(names[[i]]=="Italy")climateNames[predictClimate(temperature[i],raining[i])] = "moderado";
  if(names[[i]]=="Canada")climateNames[predictClimate(temperature[i],raining[i])] = "continental";
  
  i<-i+1;
}

#formateo para que sea facil de usar luego
climates <- vector();
for(i in 1:(length(temperature))){
    climates<-c(climates,(climateNames[result$cluster[i]]));
}

clustered <- data.frame(names=names,climate=climates)
View(clustered)
