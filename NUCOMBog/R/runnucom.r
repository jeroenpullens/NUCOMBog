# run with complete parameter list
# 198 parameters in total

runnucom<-function(WD,climate,environment,inival,start,end,par=NULL,type=NULL){
  setwd(WD)
  
  make_filenames(WD,climate,environment,inival,start,end)

  make_param_file(WD,par)

  system(paste(".",WD,"modelMEE",sep=""))

  if(!is.null(type)){
    out<-getData(type)
    return(out)
  }
}
