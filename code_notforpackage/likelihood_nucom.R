# test_likelihood<-likelihood_nucom(observed = data,predicted = parallel_output[,1],parameters = initialParameters[[1]])


likelihood_nucom<-function(observed,predicted,parameters,Logtype=NULL){

  likelihood1<-numeric()
  likelihood2<-numeric()
  # sumll<-numeric()
  if(Logtype=="classic"){
    sdNEE = parameters[c(nrow(parameters)-1),]
    sdWTD = parameters[c(nrow(parameters)),]
  }

  if(Logtype=="corrected"){
    sdNEE = (parameters[c(nrow(parameters)-2),]+parameters[c(nrow(parameters)-1),]*abs(observed[,3]))
    sdWTD = parameters[c(nrow(parameters)),]
  }
  

  if(any(sdNEE <= 0)) return(-Inf)
  if(any(sdWTD <= 0)) return(-Inf)

  obsWTD = !is.na(observed[,4])

  likelihood1 = dnorm(observed[,3],mean=predicted$NEE,sd=sdNEE,log=T)
  likelihood2 = dnorm((observed[obsWTD,4]/100),mean=predicted$WTD[obsWTD],sd=sdWTD,log=T)

  sumll=sum(likelihood1,likelihood2)
  return(sumll)
}
