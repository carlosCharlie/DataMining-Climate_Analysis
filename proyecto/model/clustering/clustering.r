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
data <- loadTraining(78)

temperature<-data$temperatures;
raining<-data$raining;
names<-data$names;

rm(data)
rm(dataset)
rm(datasets)

temperatureRain <- matrix(c(temperature,raining),ncol=2); #Una columna para las temperaturas y otra para las lluvias.

# Clustering jerárquico para ver cuantos grupos tiene sentido hacer
plot(hclust(dist(temperatureRain)))

index <- match("Panama",names);
centers<-matrix(c(temperature[[index]],raining[[index]]),ncol=2);

index <- match("Saudi Arabia",names);
centers<-rbind(centers,c(temperature[[index]],raining[[index]]));

index <- match("Italy",names);
centers<-rbind(centers,c(temperature[[index]],raining[[index]]));

index <- match("Canada",names);
centers<-rbind(centers,c(temperature[[index]],raining[[index]]));

result <- kmeans(temperatureRain,centers)

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


#Analizo Francia ano por ano por ejemplo
source("cargarDatasets.r")
country <- normalizarANormal(na.omit(datasets))[[1]][["france"]]

climates <- vector();
p <- vector();
rains <-vector();
temperatures <-vector();
distances <-vector();

for(year in country$Year){
  
  rainTmp <- vector();
  for(month in (grep("[A-Za-z]*Rain",colnames(country), perl=TRUE, value=TRUE)))
    rainTmp <- c(rainTmp,subset(country,Year==year)[[month]]);
  
  raining <- mean(rainTmp);
  
  temperatureTmp <- vector();
  for(month in (grep("[A-Za-z]*Temperature",colnames(country), perl=TRUE, value=TRUE)[1:12]))
    temperatureTmp <- c(temperatureTmp,subset(country,Year==year)[[month]]);
  
  temperature <- mean(temperatureTmp);
  
  climates <- c(climates,climateNames[predictClimate(temperature,raining)]);
  
  #Mido la distancia de Francia al clima seco.
  distances <-c(distances,dist(rbind(c(temperature,raining),result$centers[which(climateNames=="seco"),]),method="euclidean")[[1]]);
  rains <- c(rains,raining);
  temperatures<-c(temperatures,temperature);
}

plot(matrix(c(country$Year,temperatures),ncol = 2),type="l",col="red",lwd=3);
lines(matrix(c(country$Year,rains),ncol = 2),type="l",col="blue",lwd=3);

#dibujo la distancia al clima seco durante los anos
plot(matrix(c(country$Year,distances),ncol = 2),type="l",col="orange",lwd=3);

countryResult <- data.frame(year=country$Year,climates=climates,distanciaSeco=distances)
View(countryResult)
