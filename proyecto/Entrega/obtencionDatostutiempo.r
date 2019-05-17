#################################################################################
# ObtencionDatosTuTiempo.R
#
# Archivo que realiza la coexión con la página web tutiempo.net y obtiene los
# datasets.
#
#################################################################################


rm(list=ls())

# urls
webMinable <- "https://en.tutiempo.net/climate/"
sourceWeb <- "https://en.tutiempo.net"

# Paquetes necesarios para la ejecución.
if(!require("devtools")) install.packages("devtools")
require("devtools")
if (!require("RHTMLForms")) devtools::install_github("omegahat/RHTMLForms")
require("RHTMLForms")
if (!require("RCurl")) install.packages("RCurl", dependencies=TRUE)
require("RCurl")
if (!require("XML")) install.packages("XML", dependencies=TRUE)
require("XML")
if (!require("httr")) install.packages("httr", dependencies=TRUE)
require("httr")

# La url existe
if(url.exists(webMinable)) { 

  # Obtención de la página web.  
  theWebPage <- getURL(webMinable, ssl.verifypeer = FALSE)
  
  # Se obtienen los distintos datos validos del html.
  parsedWebFormSubmitResults <- htmlParse(theWebPage)

  # Se obtienen todaos los links
  parsedWebFormSubmitResultsLinks <- getHTMLLinks(parsedWebFormSubmitResults)

  # Creación de un vector de booleanos usando los links obtenidos en la instruccion anterior. Si el link comienza por "/climate/" será TRUE,
  # en otro caso FALSE.
  zonesOfWorld <- grepl(patter="^/climate/",parsedWebFormSubmitResultsLinks)
  
  #Finalmente de todos los links obtenidos se obtienen solo aquellos que comiencen por /climate/
  linksToView <- parsedWebFormSubmitResultsLinks[zonesOfWorld]

  #Estos links hacen referencia a los continentes, y se procede a recorrerlos para acceder a sus paises
  for (i in linksToView){

      continentWeb <- paste(sourceWeb,i,sep="")

      if(url.exists(continentWeb)) {

        theContinentPage <- getURL(continentWeb, ssl.verifypeer = FALSE)
  
        # Se obtienen los distintos datos validos del html.
        parsedContinentWeb <- htmlParse(theContinentPage)

        #Se obtienen todos los links.
        parsedContinentWebLinks <- getHTMLLinks(parsedContinentWeb)

        # Creacion de un vector de booleanos usando los links obtenidos en la instruccion anterior. Si el link comienza por "/climate/" será TRUE,
        # en otro caso FALSE.
        countriesOfContinent <- grepl(patter="^/climate/",parsedContinentWebLinks)
  
        #De todos los links de la pagina del continente nos quedamos con aquellos que comiencen por /climate/ ya que hacen referencia a los paises
        countriesToView <- parsedContinentWebLinks[countriesOfContinent]

        #Para mas adelante guardar los datos en carpetas obtenemos el nombre del continente de la url introducida previamente
	      continentName <- substr(i, 10 ,(nchar(i)-5))

        #Repetimos las operaciones realizadas para los continentes con los países dentro de cada continente
        for (j in countriesToView) {

          countryWeb <- paste(sourceWeb,j,sep="")

          if(url.exists(countryWeb) && j != "/climate/guam.html") {

              theCountryPage <- getURL(countryWeb, ssl.verifypeer = FALSE)
        
              #Se obtienen los distintos datos validos del html
              parsedCountryWeb <- htmlParse(theCountryPage, options=NOERROR)

              #Se obtienen todas las etiquetas a href
              parsedCountryWebLinks <- getHTMLLinks(parsedCountryWeb)

              #Creacion de un vector de booleanos usando los links obtenidos en la instruccion anterior. Si el link comienza por "/climate/" será TRUE,
              #en otro caso false
              citiesOfCountry <- grepl(patter="^/climate/ws",parsedCountryWebLinks)
              citiesToView <- parsedCountryWebLinks[citiesOfCountry]
              countryName <- substr(j, 10 ,(nchar(j)-5))

  	          countryDataFrame <- data.frame()

              #A continuacion se recorren las ciudades para agregar los datos de estas e introducir un único ejemplo por año
              #que contenga la temperatura media del pais, las lluvias totales, velocidad media del viento y los días de lluvia,tormenta,nieve,niebla,tornado y granizo
              for(k in citiesToView) {

                  cityWeb <- paste(sourceWeb,k,sep="")

                  if(url.exists(cityWeb)){

                      theCityPage <- getURL(cityWeb, ssl.verifypeer = FALSE)

                      # Se obtienen los distintos datos válidos del html.
                      parsedCityWeb <- htmlParse(theCityPage)
                      #Se obtiene la tabla de la pagina, y tras observar los datos devueltos se ve que la tabla necesaria es la 4
                      parsedCityTables <- readHTMLTable(parsedCityWeb)
                      table <- parsedCityTables[4]
                      #Por ultimo transformamos la tabla en un data.frame y establecemos que el caracter "-" representa valores nulos
                  		table <- data.frame(table)
                  		table[table=="-"] <- NA 
                      #Y si hay datos validos y la tabla es un data.frame se añaden las filas al dataframe
                  		if(is.data.frame(table) && nrow(table)>0) {
                          countryDataFrame <- rbind(countryDataFrame ,table)
                      }		
                  }
              }
          }
          #Tras esto tendremos en cada pais un conjunto de ejemplos en el que cada uno tiene la información anual de una ciudad en un año.
          #Por lo tanto ahora se procede a agregar los datos de la ciudades
          if(nrow(countryDataFrame)>0) {
              #Primero se modifica el nombre de las variables para que puedan ser accedidas de forma más sencilla
 		          names <- c("Year","ATemperature","AMaxTemperature","AMinTemperature","TotalPrecipitation","AWindSpeed","RainDays","SnowDays","StormDays","FoggyDays","TornadoDays","HailDays")
 		          colnames(countryDataFrame) <-names 
              
              #Y se transforman las columnas a numericas, ya que todas tenian el tipo factor
      			  for(name in names) {
      	  			  countryDataFrame[name] <- apply(countryDataFrame[name],2, as.character)
                	countryDataFrame[name] <- apply(countryDataFrame[name],2, as.numeric)
      	 		  }
              #Por ultimo recorremos los años del minimo al máximo y se agregan los datos calculando la media de cada variable por cada año
        	 		for(year in min(countryDataFrame$Year):max(countryDataFrame$Year)){
            	 		yearSet <- countryDataFrame[countryDataFrame$Year==year,]
            	 		yearSet <- apply(yearSet, 2, mean, na.rm=TRUE)	  
            	 		countryDataFrame <- subset(countryDataFrame, Year!=year)
            	  	countryDataFrame <- rbind(countryDataFrame, yearSet)
        	    }
              #Finalmente se escribe el dataframe a un archivo 
        			title = paste(countryName,".csv",sep="")
        			title = paste(continentName,title,sep="/")	   		
        			title = paste("datasets/tuTiempo/",title, sep="")
				      write.csv(countryDataFrame, file=title, row.names=FALSE)
	        }    
        }
      }
  } 

  free(parsedWebFormSubmitResults)
}