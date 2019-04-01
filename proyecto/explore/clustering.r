
temperaturas<-c(10:20);  #cambiar por un vector de TODAS las temperaturas
lluvias<-c(20:30);       #cambiar por un vector de TODAS las lluvias

temperatureRain <- matrix(c(temperaturas,lluvias),ncol=2); #Una columna para las temperaturas y otra para las lluvias.
result <- kmeans(temperatureRain,5)

#para dibujar
plot(temperatureRain,col=result$cluster)
  