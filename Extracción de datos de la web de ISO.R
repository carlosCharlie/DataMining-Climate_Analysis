
# Borra todos los datos y librerías cargados, generados y/o usados previamente
rm(list=ls())

webMinable <- "https://www.iso.org/standards-catalogue/browse-by-tc.html"
# webMinable <- "https://www.iso.org/committee/48104/x/catalogue/"

if (!require("devtools")) install.packages("devtools")
require(devtools)
if (!require("RHTMLForms")) install_github("omegahat/RHTMLForms")
require("RHTMLForms")
if (!require("RCurl")) install.packages("RCurl")
require(RCurl)
if (!require(XML)) install.packages("xml")
require(XML)

if(url.exists(webMinable)) 
{     # Abre la página web en el navegador por defecto
      browseURL(webMinable)
  
      theWebPage <- getURL(webMinable, ssl.verifypeer = FALSE)
      theParsedWebPage <- htmlParse(theWebPage)

      theParsedWebPageMainTable <- readHTMLTable(theParsedWebPage, which = 1)
      theParsedWebPageLinks <- getHTMLLinks(theParsedWebPage)
      free(theParsedWebPage)

      firstUsefulLink <- 52 ; lastUsefulLink <- 300
      linkNewColumn <- theParsedWebPageLinks[firstUsefulLink:lastUsefulLink]

      newDataFramewithURLs <- data.frame(
        Committee = as.vector(theParsedWebPageMainTable$Committee),
        Title = as.vector(theParsedWebPageMainTable$Title),
        Link = linkNewColumn
        )
      
      newDataFramewithURLs <- cbind(theParsedWebPageMainTable, Link = linkNewColumn)
      
      print(newDataFramewithURLs$Link[newDataFramewithURLs$Committee=="ISO/TC 37"])
      # [1] /contents/data/committee/04/81/48104/x/catalogue/
      #  249 Levels: /contents/data/committee/04/50/45020/x/catalogue/ ... /contents/data/committee/73/14/7314327/x/catalogue/
        
      # URL real para acceder a la página: "https://www.iso.org/contents/data/committee/04/81/48104/x/catalogue/"
      # Para acceder, habrá que añadir, por delante, la URL del servidor ("https://www.iso.org")
      theParsedWebPageLinksPrefix <- "https://www.iso.org"
      
      webMinable <- paste(theParsedWebPageLinksPrefix, 
                          newDataFramewithURLs$Link[newDataFramewithURLs$Committee=="ISO/TC 37"],
                          sep="")
      
      if(url.exists(webMinable)) 
      {     # Abre la página web en el navegador por defecto
        browseURL(webMinable)
        
        # Redirige a: "https://www.iso.org/committee/48104/x/catalogue/"
        webMinable <- gsub(pattern="contents/data/committee/04/81", replacement="committee", webMinable)
        
        theWebPage <- getURL(webMinable, ssl.verifypeer = FALSE)
        theParsedWebPage <- htmlParse(theWebPage)
        
        theParsedWebPageMainTable <- readHTMLTable(theParsedWebPage, which = 1)
        free(theParsedWebPage)
        
        totalPublishedStandards <- sum(as.integer(as.vector(theParsedWebPageMainTable$`Published standards`)))
        print(totalPublishedStandards)
        
      }
        
      

}

