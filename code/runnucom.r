# make function to run modelMEE ----
# run with complete parameter list
# 198 parameters in total

source("code/make_param_file_complete.r")
runnucom<-function(WD,par,type=NULL){
  make_param_file(par)
  system("./modelMEE")
  
  if(!is.null(type)){
    out<-getData(type)
    return(out)  
  }
}