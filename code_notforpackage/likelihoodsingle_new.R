# Parallel Likelihood Example
likelihoodsingle_new <- function(x){
  setup=setup_SMC
  names=names
  parameters=x
  scaled=F
  originalvalues=x
  Logtype="corrected"
  
  parameters<-data.frame(names,parameters)
  names(parameters)<-c("names",rep("values",ncol(parameters)-1))
  parameters$names<-as.character(parameters$names)

  output<- NUCOMBog::runNUCOM(setup=setup,parameters=parameters) #this returns NEE and WTD, and we calculate the likelihood on that
  
  likelihoods<-numeric()
  #   runParameters<-setup$runParameters
  #   runParameters<-combine_setup_parameters(runParameters = runParameters,parameters = parameters)
  
  for(i in 1:(ncol(parameters)-1)){ #because one column is the names
    j=i+1
    likelihoods[i] <- likelihood_nucom(observed = data,predicted = output,parameters = parameters[j],Logtype=Logtype)
  }
  return(as.matrix(likelihoods))
}