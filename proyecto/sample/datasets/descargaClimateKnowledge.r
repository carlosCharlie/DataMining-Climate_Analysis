
#poner el directorio en la raiz "proyecto" ---> setwd("~/Github/MIN_UCM/proyecto")

countries <- read.delim2("sample/datasets/names.txt",sep="\t",header = FALSE);
print(countries);

for(i in 1:(length(countries[,1]))){
  
  print(as.character(countries[i,1]));
  
  url <- paste("https://climateknowledgeportal.worldbank.org/api/data/get-download-data/historical/tas/1991-2016/",toupper(substr(countries[i,1],1,3)),"/",countries[i,1],sep="");
  print(url);
  tmp <- RCurl::getURL(url);
  write.csv(tmp, file = paste("sample/datasets/climateKnowledge/",toupper( gsub(" ","_",countries[i,1])),"_temperature.csv"));
  
  url <- paste("https://climateknowledgeportal.worldbank.org/api/data/get-download-data/historical/pr/1991-2016/",toupper(substr(countries[i,1],1,3)),"/",countries[i,1],sep="");
  print(url);
  tmp <- RCurl::getURL(url);
  write.csv(tmp, file = paste("sample/datasets/climateKnowledge/",toupper( gsub(" ","_",countries[i,1])),"_rain.csv"));
}