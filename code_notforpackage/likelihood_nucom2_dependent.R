# test_likelihood<-likelihood_nucom(observed = data,predicted = parallel_output[,1],parameters = initialParameters[[1]])


likelihood_nucom2<-function(observed,predicted,parameters,Logtype=NULL){

  
  
  likelihood1<-numeric()
  likelihood2<-numeric()
  # sumll<-numeric()
  if(Logtype=="classic"){
    sdNEE = parameters[c(nrow(parameters)-1),]
    sdWTD = parameters[c(nrow(parameters)),]
  }

  if(Logtype=="corrected"){
    sdNEE = (parameters[c(nrow(parameters)-1),])#+(parameters[c(nrow(parameters)-1),]*abs(observed[,3]))
    sdWTD = parameters[c(nrow(parameters)),]
  }

  if(any(sdNEE <= 0)) return(-Inf)
  if(any(sdWTD <= 0)) return(-Inf)

  obsWTD = !is.na(observed[,4])

  likelihood1 = dnorm(x = predicted$NEE,mean=observed[,3],sd=abs(0.25*observed[,3]),log=T)
  likelihood2 = dnorm(x=predicted$WTD[obsWTD],mean=(observed[obsWTD,4]/100),sd=sdWTD,log=T)
  # likelihood2=1
  sumll=sum(likelihood1,likelihood2,na.rm=T)
  return(sumll)
}
