# Parallel Likelihood Example
likelihoodParallel <- function(setup,clustertype,numCores,parameters,scaled=T,originalvalues,Logtype){

  print(paste("scaled = ",scaled,sep=""))
  if(scaled == TRUE){
    parameters<-parameters[2:ncol(parameters)]*originalvalues[2:ncol(originalvalues)]
    parameters<-data.frame(c(originalvalues[1],parameters))
    names(parameters)<-c("names",rep("values",ncol(parameters)-1))
    parameters$names<-as.character(parameters$names)
  }

  parallel_output<- runparallelNUCOM(setup,clustertype,numCores,parameters=parameters) #this returns NEE and WTD, and we calculate the likelihood on that

  likelihoods<-numeric()
  #   runParameters<-setup$runParameters
  #   runParameters<-combine_setup_parameters(runParameters = runParameters,parameters = parameters)

  for(i in 1:(ncol(parameters)-1)){ #because one column is the names
    j=i+1
    likelihoods[i] <- likelihood_nucom(observed = data,predicted = parallel_output[,i],parameters = parameters[j],Logtype=Logtype)
  }
  return(as.matrix(likelihoods))
}
