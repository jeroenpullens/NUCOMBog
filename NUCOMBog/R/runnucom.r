# run with complete parameter list
# 198 parameters in total

# runnucom(WD="/home/jeroen/test_package/",climate="ClimateLVM.txt",environment="EnvironmentLVM.txt",inival="inivalLVM.txt",start=1800,end=1805,type=c("GPP","WTD"))

runnucom<-function(WD,climate,environment,inival,start,end,par=NULL,type=NULL){
  setwd(WD)
  
  make_filenames(WD,climate,environment,inival,start,end)

  make_param_file(WD,par)

  system("./modelMEE")

  if(!is.null(type)){
    out<-getData(type)
    return(out)
  }
}
