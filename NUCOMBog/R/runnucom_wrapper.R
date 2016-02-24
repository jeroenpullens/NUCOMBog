runnucom_wrapper<-function(runParameters){

  setwd(dir = runParameters$runDir)

  make_filenames(WD = runParameters$runDir,climate = runParameters$climate,environment = runParameters$environment,inival = runParameters$inival,start = runParameters$start,end = runParameters$end)

  allpar<-make_param_file(WD = runParameters$runDir,par = runParameters$parameter)
  startval<- runParameters$startval

  system("./modelMEE")

  if(!is.null(runParameters$type)){
    out<-getData(runParameters,startval)
    return(out)
  }

}
