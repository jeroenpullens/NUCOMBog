# Parallel Likelihood Example
likelihoodsingle_all_sites <- function(x){
  setup_canada=setup_SMC_canada
  setup_ireland=setup_SMC_ireland
  setup_italy=setup_SMC_italy
  names=names
  parameters=x
  scaled=F
  originalvalues=x
  Logtype="corrected"
  
  parameters<-data.frame(names,parameters)
  names(parameters)<-c("names",rep("values",ncol(parameters)-1))
  parameters$names<-as.character(parameters$names)

  output_canada<- NUCOMBog::runNUCOM(setup=setup_canada,parameters=parameters) #this returns NEE and WTD, and we calculate the likelihood on that
  output_ireland<- NUCOMBog::runNUCOM(setup=setup_ireland,parameters=parameters) #this returns NEE and WTD, and we calculate the likelihood on that
  output_italy<- NUCOMBog::runNUCOM(setup=setup_italy,parameters=parameters) #this returns NEE and WTD, and we calculate the likelihood on that
  
  
  likelihoods_canada<-numeric()
  likelihoods_ireland<-numeric()
  likelihoods_italy<-numeric()
  likelihoods<-numeric()
  #   runParameters<-setup$runParameters
  #   runParameters<-combine_setup_parameters(runParameters = runParameters,parameters = parameters)
  
  for(i in 1:(ncol(parameters)-1)){ #because one column is the names
    j=i+1
    likelihoods_canada[i] <- likelihood_nucom2(observed = data_canada,predicted = output_canada,parameters = parameters[j],Logtype=Logtype)
    likelihoods_ireland[i] <- likelihood_nucom2(observed = data_ireland,predicted = output_ireland,parameters = parameters[j],Logtype=Logtype)
    likelihoods_italy[i] <- likelihood_nucom2(observed = data_italy,predicted = output_italy,parameters = parameters[j],Logtype=Logtype)
    likelihoods[i]<-sum(likelihoods_canada[i],likelihoods_ireland[i],likelihoods_italy[i])
  }
  return(as.matrix(likelihoods))
}