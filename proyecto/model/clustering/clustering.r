
predictClimate <- function(temperature,raining){
  
  if(!require("clue"))
    install.packages("clue");
  require("clue");
  
  clue::cl_predict(result,matrix(c(temperature,raining),ncol=2));
}

#Ejecutar todo el script hasta que salga un grafico con los grupos bien diferenciados
source("model/clustering/cargaFinalClustering.r")

data <- loadTraining(70); #esta funcion esta en cargaFinalClustering.r

temperature<-data$temperatures;
raining<-data$raining;
names<-data$names;

temperatureRain <- matrix(c(temperature,raining),ncol=2); #Una columna para las temperaturas y otra para las lluvias.

#clustering jerarquico para ver cuantos grupos tiene sentido hacer
plot(hclust(dist(temperatureRain)))

result <- kmeans(temperatureRain,5)

#para dibujar
plot(temperatureRain,col=result$cluster)

#pongo nombres a los climas
climateNames <- vector(mode = "character",length = 4);
climateNames[predictClimate(mean(as.double(na.omit(read.csv2(stringsAsFactors = FALSE,"sample/datasets/datasetsFinales/Panama.csv",header = TRUE, sep = ",")$Temperature))),mean(as.double(na.omit(read.csv2(stringsAsFactors = FALSE,"sample/datasets/datasetsFinales/Panama.csv",header = TRUE, sep = ",")$Rain))))] = "tropical";
climateNames[predictClimate(mean(as.double(na.omit(read.csv2(stringsAsFactors = FALSE,"sample/datasets/datasetsFinales/Saudi Arabia.csv",header = TRUE, sep = ",")$Temperature))),mean(as.double(na.omit(read.csv2(stringsAsFactors = FALSE,"sample/datasets/datasetsFinales/Saudi Arabia.csv",header = TRUE, sep = ",")$Rain))))] = "seco";
climateNames[predictClimate(mean(as.double(na.omit(read.csv2(stringsAsFactors = FALSE,"sample/datasets/datasetsFinales/Italy.csv",header = TRUE, sep = ",")$Temperature))),mean(as.double(na.omit(read.csv2(stringsAsFactors = FALSE,"sample/datasets/datasetsFinales/Italy.csv",header = TRUE, sep = ",")$Rain))))] = "moderado";
climateNames[predictClimate(mean(as.double(na.omit(read.csv2(stringsAsFactors = FALSE,"sample/datasets/datasetsFinales/Canada.csv",header = TRUE, sep = ",")$Temperature))),mean(as.double(na.omit(read.csv2(stringsAsFactors = FALSE,"sample/datasets/datasetsFinales/Canada.csv",header = TRUE, sep = ",")$Rain))))] = "continental";
climateNames[predictClimate(mean(as.double(na.omit(read.csv2(stringsAsFactors = FALSE,"sample/datasets/datasetsFinales/Thailand.csv",header = TRUE, sep = ",")$Temperature))),mean(as.double(na.omit(read.csv2(stringsAsFactors = FALSE,"sample/datasets/datasetsFinales/Thailand.csv",header = TRUE, sep = ",")$Rain))))] = "tropical-seco";

#Imprimo por pantalla
for(i in 1:(length(temperature)))
    print(paste("el clima de",gsub("-"," ",gsub("^([a-z,A-Z,-]*/)*|.csv","",data$names[i])),"es",climateNames[result$cluster[i]]))
