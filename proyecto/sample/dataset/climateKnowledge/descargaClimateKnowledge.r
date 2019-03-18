
countries <- read.delim2("sample/dataset/names.txt",sep="\t",header = FALSE);
print(countries);

for(i in 1:(length(countries[,1]))){
  print(as.character(countries[i,1]));
  tmp <- RCurl::getURL(paste("https://climateknowledgeportal.worldbank.org/api/data/get-download-data/historical/pr/1991-2016/",substr(countries[i,1],1,3),"/",countries[i,1]));
  write.csv(tmp, file = paste("sample/dataset/climateKnowledge/",toupper( gsub(" ","_",countries[i,1])),"_rain.csv"));
}

