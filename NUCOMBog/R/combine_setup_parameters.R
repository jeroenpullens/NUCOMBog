combine_setup_parameters<-function(runParameters,parameters){

  runParameters<-rep(runParameters,length(parameters)/length(runParameters))
  for(i in 1:length(runParameters)){
    runParameters[[i]]$parameters<-data.frame(parameters[i])
  }
  return(runParameters)
}
