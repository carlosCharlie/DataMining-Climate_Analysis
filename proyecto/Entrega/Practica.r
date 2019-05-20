#Sample
#En la fase de sample se obtienen los datos de las paginas web
source("obtencionDatosKnowledge.r")
source("obtencionDatostutiempo.r")
print("Sample Finalizado")
rm(list=ls())
#Explore
#En la fase de explore se analizan los datos obtenidos previamente
source("graficas.r")
source("cargarDatasets.r")
data <- cargar("datasets/climateKnowledge/")
print("Explore Finalizado")
rm(list=ls())
#Modify
#En la fase de modify se reestructuran los datos a una forma adecuada, se calculan algunos NA y se normalizan los datos
source("limpiarDataset.r")
source("mezclarDatasets.r")
source("cargarDatasets.r")
source("agrupaciones.r")
datasets <- cargar("datasetsFinales/")
data <- NULL
for(i in datasets){
	data <- rbind(data,i)
}

data <- calcularMediasAnuales(data)
data <- calcularMinAnuales(data)
data <- calcularMaxAnuales(data)
data <- calcularPrecipitacionesAnuales(data)

results <- normalizarANormal(data)

data <- results[[1]]
mean <- results[[2]]
std <- results[[3]]

write.csv(data,"datasetFinal/climate.csv",row.names=FALSE)

Temperature <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"ATemperature"])})

Rain <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"APrecipitation"])})

dataAgregatedOneYearPerCountry <- data.frame(Country=unique(data$Country),ATemperature=Temperature,APrecipitation=Rain)

write.csv(dataAgregatedOneYearPerCountry,"datasetFinal/climatePerCountry2Var.csv",row.names=FALSE)

data2 <- agregarSemestres(data)


HotMonthsT <- sapply(unique(data2$Country),function(x){mean(data2[data2$Country==x,"HotMonthsT"])})

ColdMonthsT <- sapply(unique(data2$Country),function(x){mean(data2[data2$Country==x,"ColdMonthsT"])})

HotMonthsR <- sapply(unique(data2$Country),function(x){mean(data2[data2$Country==x,"HotMonthsR"])})

ColdMonthsR <- sapply(unique(data2$Country),function(x){mean(data2[data2$Country==x,"ColdMonthsR"])})

dataAgregatedOneYearPerCountry <- data.frame(Country=unique(data2$Country),ColdMonthsT = ColdMonthsT, HotMonthsT = HotMonthsT,ColdMonthsR = ColdMonthsR, HotMonthsR = HotMonthsR)

write.csv(dataAgregatedOneYearPerCountry,"datasetFinal/climatePerCountry4Var.csv",row.names=FALSE)

JanTemperature <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"JanTemperature"])})
FebTemperature <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"FebTemperature"])})
MarTemperature <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"MarTemperature"])})
AprTemperature <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"AprTemperature"])})
MayTemperature <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"MayTemperature"])})
JunTemperature <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"JunTemperature"])})
JulTemperature <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"JulTemperature"])})
AugTemperature <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"AugTemperature"])})
SepTemperature <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"SepTemperature"])})
OctTemperature <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"OctTemperature"])})
NovTemperature <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"NovTemperature"])})
DecTemperature <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"DecTemperature"])})

JanRain <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"JanRain"])})
FebRain <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"FebRain"])})
MarRain <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"MarRain"])})
AprRain <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"AprRain"])})
MayRain <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"MayRain"])})
JunRain <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"JunRain"])})
JulRain <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"JulRain"])})
AugRain <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"AugRain"])})
SepRain <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"SepRain"])})
OctRain <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"OctRain"])})
NovRain <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"NovRain"])})
DecRain <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"DecRain"])})

AMinTemperature <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"AMinTemperature"])})
AMaxTemperature <- sapply(unique(data$Country),function(x){mean(data[data$Country==x,"AMaxTemperature"])})

dataAgregatedOneYearPerCountry <- data.frame(Country=unique(data$Country),JanTemperature=JanTemperature,FebTemperature=FebTemperature,MarTemperature=MarTemperature,AprTemperature=AprTemperature,
								MayTemperature=MayTemperature,JunTemperature=JunTemperature,JulTemperature=JulTemperature,AugTemperature=AugTemperature,SepTemperature=SepTemperature,
								OctTemperature=OctTemperature,NovTemperature=NovTemperature,DecTemperature=DecTemperature,JanRain=JanRain,FebRain=FebRain,MarRain=MarRain,
								AprRain=AprRain,MayRain=MayRain,JunRain=JunRain,JulRain=JulRain,AugRain=AugRain,SepRain=SepRain,OctRain=OctRain,NovRain=NovRain,DecRain=DecRain,
								ATemperature=Temperature,AMinTemperature=AMinTemperature,AMaxTemperature=AMaxTemperature,APrecipitation=Rain)

write.csv(dataAgregatedOneYearPerCountry,"datasetFinal/climatePerCountryAllVar.csv",row.names=FALSE)

write.csv(data2,"datasetFinal/climate4Var.csv",row.names=FALSE)

rm(list=ls()[ls()!="mean" & ls()!="std"])
print("Modify Finalizado")
#Model
source("clustering.r")

#A continuacion se realizan varios clusterings con distintos conjuntos de variables y agregaciones y con los resultados más
#adecuados se procede a crear el arbol de decisión
data <- read.csv("datasetFinal/climate.csv",header=TRUE)

set.seed(0)

#Se harán dos conjuntos de pruebas, unas agregando todos los ejemplos de los paises y otras utilizando todos los ejemplos.
#Para cada conjunto se realizan diferentes conjuntos de variables para el entrenamiento.


#Primera prueba, por cada país disponemos de un ejemplo, que tiene como campos, la temperatura media, agregando las medias anuales de
#todos los años, y la lluvia media agregando las lluvias de todos los años
dataAgregatedOneYearPerCountry <- read.csv("datasetFinal/climatePerCountry2Var.csv",header=TRUE)

plot(hclust(dist(dataAgregatedOneYearPerCountry[2:3])))

#Tras ver el diagrama se consideran apropiados 4-5 clusters

result4 <- kmeans(dataAgregatedOneYearPerCountry[2:3],4)

plot(dataAgregatedOneYearPerCountry[2:3],col=result4$cluster)

result5 <- kmeans(dataAgregatedOneYearPerCountry[2:3],5)

plot(dataAgregatedOneYearPerCountry[2:3],col=result5$cluster)

climate1 <- predictClimate(result4,data,c("ATemperature","APrecipitation"))

#Segunda prueba agregados 6 meses
dataAgregatedOneYearPerCountry <- read.csv("datasetFinal/climatePerCountry4Var.csv",header=TRUE)

plot(hclust(dist(dataAgregatedOneYearPerCountry[2:length(dataAgregatedOneYearPerCountry)])))

result4 <- kmeans(dataAgregatedOneYearPerCountry[2:length(dataAgregatedOneYearPerCountry)],4)

plot(matrix(c(Temperature,Rain),ncol=2),col=result4$cluster)

climate2 <- predictClimate(result4,data2,c("ColdMonthsT","HotMonthsT","ColdMonthsR","HotMonthsR"))

#Ultima prueba utilizando todas las variables menos el año y el país
dataAgregatedOneYearPerCountry <- read.csv("datasetFinal/climatePerCountryAllVar.csv",header=TRUE)
plot(hclust(dist(dataAgregatedOneYearPerCountry[2:length(dataAgregatedOneYearPerCountry)])))

result4 <- kmeans(dataAgregatedOneYearPerCountry[2:length(dataAgregatedOneYearPerCountry)],4)

result5 <- kmeans(dataAgregatedOneYearPerCountry[2:length(dataAgregatedOneYearPerCountry)],5)

result6 <- kmeans(dataAgregatedOneYearPerCountry[2:length(dataAgregatedOneYearPerCountry)],6)

climate3 <- predictClimate(result4,data,c("JanTemperature","FebTemperature","MarTemperature","AprTemperature","MayTemperature","JunTemperature","JulTemperature",
								"AugTemperature","SepTemperature","OctTemperature","NovTemperature","DecTemperature","JanRain","FebRain","MarRain",
								"AprRain","MayRain","JunRain","JulRain","AugRain","SepRain","OctRain","NovRain","DecRain",
								"ATemperature","AMinTemperature","AMaxTemperature","APrecipitation"))

#Mismas pruebas pero utilizando todos los ejemplos
#Datos de temperaturas y lluvias medias anuales
plot(hclust(dist(data[c("ATemperature","APrecipitation")])))

result3 <- kmeans(data[c("ATemperature","APrecipitation")],3)

result4 <- kmeans(data[c("ATemperature","APrecipitation")],4)

result5 <- kmeans(data[c("ATemperature","APrecipitation")],5)

climate4 <- result4$cluster


#Con datos agregados por semestres fríos y cálidos
data2 <- read.csv("datasetFinal/climate4Var.csv",header=TRUE)

plot(hclust(dist(data2[c("ColdMonthsT","HotMonthsT","ColdMonthsR","HotMonthsR")])))

result3 <- kmeans(data2[c("ColdMonthsT","HotMonthsT","ColdMonthsR","HotMonthsR")],3)

result5 <- kmeans(data2[c("ColdMonthsT","HotMonthsT","ColdMonthsR","HotMonthsR")],5)

climate5 <- result5$cluster


#Con todas las variables disponibles (sin año ni país)
plot(hclust(dist(data[3:length(data)])))

result4 <- kmeans(data[3:length(data)],4)

climate6 <- result4$cluster

#A continuacion con los 6 resultados obtenidos se entrenan y validan arboles de decision, de forma que se puede
#comprobar si los resultados obtenidos por el clustering son satisfactorios. Si esto es así el arbol
#debe ser capaz de predecir el clima. Finalmente se evaluarán los resultdos y se decidirá que clustering es más adecuado y cuál
#sería el árbol de decision resultante

data$Climate <- as.factor(climate1)
aplicarDecisionTree(data[3:length(data)])

data$Climate <- as.factor(climate2)
aplicarDecisionTree(data[3:length(data)])

data$Climate <- as.factor(climate3)
aplicarDecisionTree(data[3:length(data)])

data$Climate <- as.factor(climate4)
aplicarDecisionTree(data[3:length(data)])

data$Climate <- as.factor(climate5)
aplicarDecisionTree(data[3:length(data)])

data$Climate <- as.factor(climate6)
aplicarDecisionTree(data[3:length(data)])

#Finalmente comprobamos como evoluciona el clima de algunos países

resultadoMasAdecuado <- result4

distances <- lapply(data[data$Country="Francia",3:length(data)],function(x){dist(rbind(x,resultadoMasAdecuado$center["seco"]), method ="euclidean")[[1]]})