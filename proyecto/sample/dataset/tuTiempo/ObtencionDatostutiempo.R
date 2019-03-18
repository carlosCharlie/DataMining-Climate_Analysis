rm(list=ls())

# webMinable <- "https://www.iso.org/standards-catalogue/browse-by-tc.html"
# webMinable <- "https://www.iso.org/committee/48104/x/catalogue/"
webMinable <- "https://en.tutiempo.net/climate/"
sourceWeb <- "https://en.tutiempo.net"

# Si fuera necesaria una descarga manual, el paquete <RHTMLForms> se puede encontrar en
# "http://www.omegahat.net/RHTMLForms/RHTMLForms_0.6-0.tar.gz"

if (!require("RHTMLForms")) install_github("omegahat/RHTMLForms")
require("RHTMLForms")
if (!require("RCurl")) install.packages("RCurl")
require(RCurl)
if (!require(XML)) install.packages("xml")
require(XML)
if (!require(httr)) install.packages("httr")
require(httr)


if(url.exists(webMinable)) 
{ 
  #Obtencion de la pagina web  
  theWebPage <- getURL(webMinable, ssl.verifypeer = FALSE)
  
  #Se obtienen los distintos datos validos del html
  parsedWebFormSubmitResults <- htmlParse(theWebPage)

  #Se obtienen todas las etiquetas a href
  parsedWebFormSubmitResultsLinks <- getHTMLLinks(parsedWebFormSubmitResults)

  #Creacion de un vector de booleanos usando los links obtenidos en la instruccion anterior. Si el link comienza por "/climate/" será TRUE,
  #en otro caso false
  zonesOfWorld <- grepl(patter="^/climate/",parsedWebFormSubmitResultsLinks)
  
  linksToView <- parsedWebFormSubmitResultsLinks[zonesOfWorld]

  for (i in linksToView){
      continentWeb <- paste(sourceWeb,i,sep="")
      if(url.exists(continentWeb)){
        theContinentPage <- getURL(continentWeb, ssl.verifypeer = FALSE)
  
        #Se obtienen los distintos datos validos del html
        parsedContinentWeb <- htmlParse(theContinentPage)

        #Se obtienen todas las etiquetas a href
        parsedContinentWebLinks <- getHTMLLinks(parsedContinentWeb)

        #Creacion de un vector de booleanos usando los links obtenidos en la instruccion anterior. Si el link comienza por "/climate/" será TRUE,
        #en otro caso false
        countriesOfContinent <- grepl(patter="^/climate/",parsedContinentWebLinks)
  
        countriesToView <- parsedContinentWebLinks[countriesOfContinent]

        for (j in countriesToView){
          countryWeb <- paste(sourceWeb,j,sep="")
          if(url.exists(countryWeb) && j != "/climate/guam.html"){
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

            for(k in citiesToView){
              cityWeb <- paste(sourceWeb,k,sep="")
              if(url.exists(cityWeb)){
                theCityPage <- getURL(cityWeb, ssl.verifypeer = FALSE)
      
                #Se obtienen los distintos datos validos del html
                parsedCityWeb <- htmlParse(theCityPage)

                parsedCityTables <- readHTMLTable(parsedCityWeb)

                table <- parsedCityTables[4]

                cityName <- substr(k, 10 ,(nchar(k)-5))

                name <- paste(countryName,cityName,sep="")

                name <- paste(name,".csv",sep="")

                write.csv(table, file=name,row.names=TRUE)
              }
            }
          }
          print("Another Country") 
        }

      }
      print("Another Continent")
  } 

  free(parsedWebFormSubmitResults)
}  
  
  
  
  
