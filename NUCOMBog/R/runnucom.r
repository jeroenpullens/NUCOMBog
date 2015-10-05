# make function to run modelMEE ----
# run with complete parameter list
# 198 parameters in total

runnucom<-function(WD,par,type=NULL){
  make_param_file(par)
  system("./modelMEE")
  
  if(!is.null(type)){
    out<-getData(type)
    return(out)  
  }
}
