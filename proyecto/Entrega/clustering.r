#################################################################################
# clustering.r
#
# Archivo para realizar el clustering, determinando cuántos clusters tiene
# sentido diferenciar según los datos de los climas de los países.
#
#################################################################################
if(!require("clue"))
    install.packages("clue");
  require("clue");
predictClimate <- function(model,data,colsUseToPredict=colnames(data)[2:length(colnames(data))]) {
 climates <- vector();
 for(i in 1:nrow(data)){
 	climates <- c(climates,clue::cl_predict(model,data[i,colsUseToPredict]))
 }
 return (climates)
}

predictClimate2 <- function(model,coldMonthsT,hotMonthsT,coldMonthsR,hotMonthsR){
  clue::cl_predict(model,matrix(c(coldMonthsT,hotMonthsT,coldMonthsR,hotMonthsR),ncol=4));
}

