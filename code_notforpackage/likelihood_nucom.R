# test_likelihood<-likelihood_nucom(observed = data,predicted = parallel_output[,1],parameters = initialParameters[[1]])


likelihood_nucom<-function(observed,predicted,parameters,Logtype=NULL){

  likelihood1<-numeric()
  likelihood2<-numeric()
  # sumll<-numeric()

  if(Logtype=="classic"){
    for(i in 1:nrow(observed)){
      likelihood1[i]=dnorm(observed[i,3],mean=predicted$NEE[i],sd=parameters[c(nrow(parameters)-1),],log=T)
      likelihood2[i]=dnorm((observed[i,4]/100),mean=predicted$WTD[i],sd=parameters[c(nrow(parameters)),],log=T)
    }
  }

  if(Logtype=="corrected"){
    for(i in 1:nrow(observed)){
      likelihood1[i]=dnorm(observed[i,3],mean=predicted$NEE[i],sd=(parameters[c(nrow(parameters)-3),]+parameters[c(nrow(parameters)-2),]*observed[i,3]),log=T)
      likelihood2[i]=dnorm((observed[i,4]/100),mean=predicted$WTD[i],sd=(parameters[c(nrow(parameters)-1),]+parameters[c(nrow(parameters)),]*(observed[i,4]/100)),log=T)
    }
  }

  sumll=sum(likelihood1,likelihood2,na.rm=TRUE)
  return(sumll)
}
