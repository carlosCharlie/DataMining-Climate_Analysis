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

  # Se obtienen todas las etiquetas a href.
  parsedWebFormSubmitResultsLinks <- getHTMLLinks(parsedWebFormSubmitResults)

  # Creación de un vector de booleanos usando los links obtenidos en la instruccion anterior. Si el link comienza por "/climate/" será TRUE,
  # en otro caso FALSE.
  zonesOfWorld <- grepl(patter="^/climate/",parsedWebFormSubmitResultsLinks)
  
  linksToView <- parsedWebFormSubmitResultsLinks[zonesOfWorld]

  for (i in linksToView){

      continentWeb <- paste(sourceWeb,i,sep="")

      if(url.exists(continentWeb)) {

        theContinentPage <- getURL(continentWeb, ssl.verifypeer = FALSE)
  
        # Se obtienen los distintos datos validos del html.
        parsedContinentWeb <- htmlParse(theContinentPage)

        #Se obtienen todas las etiquetas a href.
        parsedContinentWebLinks <- getHTMLLinks(parsedContinentWeb)

        # Creacion de un vector de booleanos usando los links obtenidos en la instruccion anterior. Si el link comienza por "/climate/" será TRUE,
        # en otro caso FALSE.
        countriesOfContinent <- grepl(patter="^/climate/",parsedContinentWebLinks)
  
        countriesToView <- parsedContinentWebLinks[countriesOfContinent]

	      continentName <- substr(i, 10 ,(nchar(i)-5))

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

              for(k in citiesToView) {

                  cityWeb <- paste(sourceWeb,k,sep="")

                  if(url.exists(cityWeb)){

                      theCityPage <- getURL(cityWeb, ssl.verifypeer = FALSE)

                      # Se obtienen los distintos datos válidos del html.
                      parsedCityWeb <- htmlParse(theCityPage)
                      parsedCityTables <- readHTMLTable(parsedCityWeb)
                      table <- parsedCityTables[4]
                  		table <- data.frame(table)
                  		table[table=="-"] <- NA 

                  		if(is.data.frame(table) && nrow(table)>0) {
                          countryDataFrame <- rbind(countryDataFrame ,table)
                      }		
                  }
              }
          }

          if(nrow(countryDataFrame)>0) {
			      #countryDataFrame<-countryDataFrame[1:5]
 		          #names <- c("Year","ATemperature","AMaxTemperature","AMinTemperature","TotalPrecipitation")
 		          names <- c("Year","ATemperature","AMaxTemperature","AMinTemperature","TotalPrecipitation","AWindSpeed","RainDays","SnowDays","StormDays","FoggyDays","TornadoDays","HailDays")
 		          colnames(countryDataFrame) <-names 
              
      			  for(name in names) {
      	  			  countryDataFrame[name] <- apply(countryDataFrame[name],2, as.character)
                	countryDataFrame[name] <- apply(countryDataFrame[name],2, as.numeric)
      	 		  }
  
        	 		for(year in min(countryDataFrame$Year):max(countryDataFrame$Year)){
            	 		yearSet <- countryDataFrame[countryDataFrame$Year==year,]
            	 		yearSet <- apply(yearSet, 2, mean, na.rm=TRUE)	  
            	 		countryDataFrame <- subset(countryDataFrame, Year!=year)
            	  	countryDataFrame <- rbind(countryDataFrame, yearSet)
        	    } 
        			title = paste(countryName,".csv",sep="")
        			title = paste(continentName,title,sep="/")	   		
        			title = paste("./sample/datasets/tuTiempo/",title, sep="")
				      write.csv(countryDataFrame, file=title, row.names=FALSE)
              print(countryName)
	        }    
        }
      }

      print("Another Continent")
  } 

  free(parsedWebFormSubmitResults)
}