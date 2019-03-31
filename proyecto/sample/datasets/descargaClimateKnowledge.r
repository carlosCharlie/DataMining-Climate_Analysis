
#poner el directorio en la raiz "proyecto" ---> setwd("~/Github/MIN_UCM/proyecto")
toDataFrame <- function(data){
	data<-strsplit(data,"\n")
  	data<-lapply(data,function(x){strsplit(x,", ")})
  	futureMatrix <- unlist(data)
  	newMatrix <- matrix(futureMatrix, nrow=length(futureMatrix)/5,ncol=5,T)
  	df <- data.frame(newMatrix[2:nrow(newMatrix),])
  	names(df) <- newMatrix[1,]
  	df
}



countries <- read.delim2("sample/datasets/names.txt",sep="\t",header = FALSE);
print(countries);

for(i in 1:(length(countries[,1]))){
  
  print(as.character(countries[i,1]));
  
  url <- paste("https://climateknowledgeportal.worldbank.org/api/data/get-download-data/historical/tas/1991-2016/",toupper(substr(countries[i,1],1,3)),"/",countries[i,1],sep="");
  print(url);
  tmp <- RCurl::getURL(url);
  if(nchar(tmp)>nchar("Temperature - (Celsius), Year, Month, Country, ISO3\n") && !grepl("<html>",tmp)){
  	#write(tmp, file = paste("sample/datasets/climateKnowledge/",toupper(gsub(" ","_",countries[i,1])),"_temperature.csv", sep=""));
  	df1 <- toDataFrame(tmp)

  	url <- paste("https://climateknowledgeportal.worldbank.org/api/data/get-download-data/historical/pr/1991-2016/",toupper(substr(countries[i,1],1,3)),"/",countries[i,1],sep="");
  	print(url);
  	tmp <- RCurl::getURL(url);
  	if(nchar(tmp)>nchar("Temperature - (Celsius), Year, Month, Country, ISO3\n") && !grepl("<html>",tmp)){
  		df2 <- toDataFrame(tmp)

  		tmp <- merge(df1,df2,by=c("Year","Country","Month","ISO3"))

  		write.csv(tmp, file = paste("sample/datasets/climateKnowledge/",toupper(gsub(" ","_",countries[i,1])),".csv",sep=""));
  	}
  }
}

#limpiando los vacios
files <- list.files(path="sample/datasets/climateKnowledge",full.names = TRUE)
lapply(files,function(x){
  file <- read.csv2(x,sep=",",header = TRUE,stringsAsFactors = FALSE);
  if(("Year" %in% colnames(file)) && length(file[,"Year"])==0){
    print(paste("borrando",x));
    file.remove(x);
  }
})