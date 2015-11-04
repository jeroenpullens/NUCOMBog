 # test_likelihood<-likelihood_nucom(observed = data,predicted = parallel_output[,1],parameters = initialParameters[[1]])


likelihood_nucom<-function(observed,predicted,parameters){

likelihood1<-numeric()
likelihood2<-numeric()
# sumll<-numeric()

  for(i in 1:nrow(observed)){
    likelihood1[i]=dnorm(observed[i,3],mean=predicted[[1]][i],sd=parameters[c(nrow(parameters)-1),],log=T)
    likelihood2[i]=dnorm((observed[i,4]/100),mean=predicted[[2]][i],sd=parameters[c(nrow(parameters)),],log=T)
  }

  sumll=sum(likelihood1,likelihood2,na.rm=TRUE)
  return(sumll)
}
