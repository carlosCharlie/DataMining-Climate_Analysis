
temperature<-c(10:20);  #cambiar por un vector de TODAS las temperaturas
raining<-c(20:30);       #cambiar por un vector de TODAS las lluvias

temperatureRain <- matrix(c(temperature,raining),ncol=2); #Una columna para las temperaturas y otra para las lluvias.
result <- kmeans(temperatureRain,5)

#para dibujar
plot(temperatureRain,col=result$cluster)

for(i in 1:(length(temperature)))
    print(paste("el clima del pais",i,"es de tipo",result$cluster[i]))