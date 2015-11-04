combine_setup_parameters<-function(runParameters,parameters){


  if(runParameters[[1]]$separate==T){
    runParameters<-rep(runParameters,nrow(parameters)/length(runParameters))
    for(i in 1:length(runParameters)){
      runParameters[[i]]$parameters<-data.frame(parameters[i,])
    }
  }

  if (runParameters[[1]]$separate==F){
    for(i in 1:(ncol(parameters)-1)){
      j=i+1
      runParameters[[i]]$parameters<-data.frame(parameters$names,parameters[,j])
      names(runParameters[[i]]$parameters)<-c("names","values")
    }
  }
  return(runParameters)
}

