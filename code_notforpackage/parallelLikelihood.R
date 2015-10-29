# a<-Sys.time()

# likelihoodParallel(setup=test_setup,clustertype = "SOCK",numCores = 1,parameters=initialParameters)

# Sys.time()-a

 # Parallel Likelihood Example
likelihoodParallel <- function(setup,clustertype,numCores,parameters){

  # setup<-setupParallel(mainDir,climate,environment,inival,start,end,type,parameters)
  # results <- run model in parallel on the list
  parallel_output<-runnucom_parallel(setup=setup,clustertype = clustertype,numCores = numCores,parameters) #this returns NEE and WTD, and we calculate the likelihood on that
  #print(parallel_output)

  likelihoods<-numeric()

  #print(setup$runParameters[[1]]$par)
  runParameters<-setup$runParameters


  runParameters<-combine_setup_parameters(runParameters = runParameters,parameters = parameters)


  for(i in 1:nparvector){
     likelihoods[i] <- likelihood_nucom(observed = data,predicted = parallel_output[,i],parameters = runParameters[[i]]$parameters)
  }

  return(as.matrix(likelihoods))
}
