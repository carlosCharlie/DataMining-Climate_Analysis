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

#Se observa la estructura de los datos
head(data$afghanistan)

#Para deteminar si existen diferencias se comparan paises de climas diferentes
plotVsMonth(data$afghanistan,"Temperature",c(2016))
plotVsMonth(data$norway,"Temperature",c(2016))
plotVsMonth(data$mexico,"Temperature",c(2016))
plotVsMonth(data$brazil,"Temperature",c(2016))

plotVsMonth(data$afghanistan,"Rain",c(2016))
plotVsMonth(data$norway,"Rain",c(2016))
plotVsMonth(data$mexico,"Rain",c(2016))
plotVsMonth(data$brazil,"Rain",c(2016))

#Se cuentan NA
nas <- lapply(data,function(x){lapply(x,function(y){sum(is.na(y))})})
print(sum(unlist(nas,use.names=FALSE)))

data <- cargar("datasets/tuTiempo/asia/")

#Se observa la estructura de los datos
head(data$afghanistan)

#Se cuentan NA
nas <- lapply(data,function(x){lapply(x,function(y){sum(is.na(y))})})
print(sum(unlist(nas,use.names=FALSE)))

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
source("arboles.r")
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
climate1Centers <- result4$centers

#Segunda prueba agregados 6 meses
data2 <- read.csv("datasetFinal/climate4Var.csv",header=TRUE)
dataAgregatedOneYearPerCountry2 <- read.csv("datasetFinal/climatePerCountry4Var.csv",header=TRUE)

plot(hclust(dist(dataAgregatedOneYearPerCountry2[2:length(dataAgregatedOneYearPerCountry2)])))

result4 <- kmeans(dataAgregatedOneYearPerCountry2[2:length(dataAgregatedOneYearPerCountry2)],4)

plot(matrix(c(dataAgregatedOneYearPerCountry$ATemperature,dataAgregatedOneYearPerCountry$APrecipitation),ncol=2),col=result4$cluster)

climate2 <- predictClimate(result4,data2,c("ColdMonthsT","HotMonthsT","ColdMonthsR","HotMonthsR"))

#Ultima prueba utilizando todas las variables menos el año y el país
dataAgregatedOneYearPerCountry3 <- read.csv("datasetFinal/climatePerCountryAllVar.csv",header=TRUE)
plot(hclust(dist(dataAgregatedOneYearPerCountry3[2:length(dataAgregatedOneYearPerCountry3)])))

result4 <- kmeans(dataAgregatedOneYearPerCountry3[2:length(dataAgregatedOneYearPerCountry3)],4)

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

climate4.4 <- result4$cluster
climate4.4Centers <- result4$centers

climate4.5 <- result5$cluster
climate4.5Centers <- result5$centers


#Con datos agregados por semestres fríos y cálidos
data2 <- read.csv("datasetFinal/climate4Var.csv",header=TRUE)

plot(hclust(dist(data2[c("ColdMonthsT","HotMonthsT","ColdMonthsR","HotMonthsR")])))

result3 <- kmeans(data2[c("ColdMonthsT","HotMonthsT","ColdMonthsR","HotMonthsR")],3)

result4 <- kmeans(data2[c("ColdMonthsT","HotMonthsT","ColdMonthsR","HotMonthsR")],4)

result5 <- kmeans(data2[c("ColdMonthsT","HotMonthsT","ColdMonthsR","HotMonthsR")],5)

climate5.4 <- result4$cluster

climate5.5 <- result5$cluster


#Con todas las variables disponibles (sin año ni país)
plot(hclust(dist(data[3:length(data)])))

result4 <- kmeans(data[3:length(data)],4)

climate6 <- result4$cluster


#Por los motivos comentados en la memoria se seleccionan las 3 siguientes posibles clasificaciones para realizar una clasificacion de los datos utilizando arboles de decisión y bosques
#aleatorios

posibleClasification1 <- as.factor(climate1)
posibleClasification2 <- as.factor(climate4.4)
posibleClasification3 <- as.factor(climate4.5)

#A continuación se prueba a crear un arbol de decisión y un bosque aleatorio por cada una de las posibles clasificaciones obtenidas de los clustering.


data$Climate <- posibleClasification1
arbol1DT <- aplicarDecisionTree(data[3:length(data)])

arbol1RF <- aplicarRandomForest(data[3:length(data)])

arbol1 <- arbol1DT

data$Climate <- posibleClasification2
arbol2DT <- aplicarDecisionTree(data[3:length(data)])

arbol2RF <- aplicarRandomForest(data[3:length(data)])

arbol2 <- arbol2DT

data$Climate <- posibleClasification3
arbol3DT <- aplicarDecisionTree(data[3:length(data)])

arbol3RF <- aplicarRandomForest(data[3:length(data)])

arbol3 <- arbol3DT



#Tras aplicar los modelos se procede a analizar los clusters dentro de cada clasificación posible para asignar un clima a cada cluster.
data$Climate <- posibleClasification1

print(climate1Centers)
print(summary(data[data$Climate==1,"Country"]))
print(summary(data[data$Climate==2,"Country"]))
print(summary(data[data$Climate==3,"Country"]))
print(summary(data[data$Climate==4,"Country"]))
#En vista a los resultados se establecen los siguientes nombres
#1 - Seco
#2 - Templado
#3 - Continental
#4 - Tropical
levels(posibleClasification1) <- c("Seco","Templado","Continental","Tropical")
rownames(climate1Centers) <- c("Seco","Templado","Continental","Tropical")  

data$Climate <- posibleClasification2

print(climate4.4Centers)
print(summary(data[data$Climate==1,"Country"]))
print(summary(data[data$Climate==2,"Country"]))
print(summary(data[data$Climate==3,"Country"]))
print(summary(data[data$Climate==4,"Country"]))
#En vista a los resultados se establecen los siguientes nombres
#1 - Seco
#2 - Tropical 
#3 - Continental
#4 - Templado
levels(posibleClasification2) <- c("Seco","Tropical","Continental","Templado")
rownames(climate4.4Centers) <- c("Seco","Tropical","Continental","Templado")

data$Climate <- posibleClasification3

print(climate4.5Centers)
print(summary(data[data$Climate==1,"Country"]))
print(summary(data[data$Climate==2,"Country"]))
print(summary(data[data$Climate==3,"Country"]))
print(summary(data[data$Climate==4,"Country"]))
print(summary(data[data$Climate==5,"Country"]))
#En vista a los resultados se establecen los siguientes nombres
#1 - Tropical 
#2 - Seco
#3 - Continental
#4 - Tropical medio
#5 - Templado
levels(posibleClasification3) <- c("Tropical","Seco","Continental","Tropical medio","Templado")
rownames(climate4.5Centers) <- c("Tropical","Seco","Continental","Tropical medio","Templado")


#Finalmente comprobamos como evoluciona el clima de algunos países

bestResult <- posibleClasification1
bestResultCenters <- climate1Centers
data$Climate <- bestResult

print(data[data$Country=="Italy",c("Year","Climate")])

print(summary(data[data$Country=="Italy","Climate"]))

#Cambiar el nivel de detalle sirve para plotear más o menos años, ya que las tempeaturas no parecen ser muy constantes y de esa forma suavizar la funcion
agregationLevel <- 10

plot(data[data$Country=="Italy",c("Year","ATemperature")][seq(1,nrow(data[data$Country=="Italy",c("Year","ATemperature")])+1,agregationLevel),],type="l",col="red",ylim=c(-1,0.5))
par(new=TRUE)
plot(data[data$Country=="Italy",c("Year","APrecipitation")][seq(1,nrow(data[data$Country=="Italy",c("Year","APrecipitation")])+1,agregationLevel),],type="l",col="blue",ylim=c(-1,0.5))
legend("topright", legend=c("Temperature","Precipitation"),fill=c("red","blue"))



distances <- apply(data[data$Country=="France",c("ATemperature","APrecipitation")],1,function(x){dist(rbind(x,bestResultCenters["Seco",]), method ="euclidean")[[1]]})

agregationLevel <- 10
whichPrint <- seq(1,length(distances)+1,agregationLevel)
plot(data[data$Country=="France","Year"][whichPrint],distances[whichPrint],type="l",col="red")

distances <- apply(data[data$Country=="Czech Republic",c("ATemperature","APrecipitation")],1,function(x){dist(rbind(x,bestResultCenters["Seco",]), method ="euclidean")[[1]]})

agregationLevel <- 10
whichPrint <- seq(1,length(distances)+1,agregationLevel)
plot(data[data$Country=="Czech Republic","Year"][whichPrint],distances[whichPrint],type="l",col="red")