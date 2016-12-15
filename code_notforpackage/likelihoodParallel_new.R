# Parallel Likelihood Example
likelihoodParallel_new <- function(x){
  setup=setup_SMC
  names=names
  parameters=t(x)
  scaled=FALSE
  originalvalues=originalvalues
  Logtype="corrected"


  print(paste("scaled = ",scaled,sep=""))
  print(parameters)
  if(scaled == TRUE){
    parameters<-parameters*originalvalues
    parameters<-data.frame(parameters)
  } 
  parameters<-data.frame(names,parameters)
 
  names(parameters)<-c("names",rep("values",ncol(parameters)-1))
  parameters$names<-as.character(parameters$names)
  
  # print(paste("Calling likelihood with", ncol(parameters)-1, "parameter combinations"))
  # print(as.data.frame(parameters))

  parallel_output <- runparallelNUCOM(setup=setup,clustertype=clustertype,numCores,parameters=parameters) #this returns NEE and WTD, and we calculate the likelihood on that

  likelihoods<-numeric()
  #   runParameters<-setup$runParameters
  #   runParameters<-combine_setup_parameters(runParameters = runParameters,parameters = parameters)

  for(i in 1:(ncol(parameters)-1)){ #because one column is the names
    j=i+1
    likelihoods[i] <- likelihood_nucom(observed = data,predicted = parallel_output[,i],parameters = parameters[j],Logtype=Logtype)
  }
  # write.csv(likelihoods,file="likelihoods.csv")
  return(as.matrix(likelihoods))

}
