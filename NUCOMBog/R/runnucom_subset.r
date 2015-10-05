# make function to run modelMEE ----
# run with most sensitive parameters
# 26 parameters in total


runnucom_subset<-function(WD,par,type=NULL){
  make_param_file_subset(par)
  system("./modelMEE")
  
  if(!is.null(type)){
    out<-getData(type)
    return(out)  
  }
}
