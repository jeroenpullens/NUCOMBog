# a<-Sys.time()
# likelihoods<-likelihoodParallel(mainDir = "/home/jeroen/test_package/",climate="clim_1999-2013_measured.txt",environment="Env_Mer_Bleue_1999_2013.txt",inival="Inival_Mer_Bleue.txt",start=1999,end=2013,type=c("NEE","WTD"),parameters=initialParameters,clustertype = "SOCK",numCores = 1)
# Sys.time()-a

 # Parallel Likelihood Example
likelihoodParallel <- function(parameters,mainDir,climate,environment,inival,start,end,type,clustertype,numCores){

  setup<-setupParallel(mainDir,climate,environment,inival,start,end,type,parameters)
  # results <- run model in parallel on the list
  parallel_output<-runnucom_parallel(Setup=setup,mainDir=mainDir,clustertype = clustertype,numCores = numCores) #this returns NEE and WTD, and we calculate the likelihood on that
  #print(parallel_output)

  likelihoods<-numeric()

  print(setup$runParameters[[1]]$par)

  for(i in 1:nparvector){
     likelihoods[i] <- likelihood_nucom(observed = data,predicted = parallel_output[,i],parameters = parameters[[i]])
  }

  return(as.matrix(likelihoods))
}
