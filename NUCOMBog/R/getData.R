#'@title Function to retrieve data from the monthly output file created by NUCOMBog
#'
#'@author JWM Pullens
#'
#'@description
#'This function returns data from the monthly output file created by NUCOMBog.
#'
#'The original model gives NPP back as output, the model has been changed to give Autotrophic respiration as output. In this way NEE can be calculated.
#'The model gives WTD in meters and a positive value means below ground level.
#'
#' This getData function is integrated in all runnucom functions.
#'
#'@param setup setup_structure described in setup_NUCOM
#'@param startval When a spinup is used for the model, not all output is needed. This "startval" parameter can be used to cut the output off, i.e. the row from which the "outmo.txt" file is loaded.
#'
#'@examples
#'\dontrun{
#'getData(setup=test_setup_singlecore,startval=1)
#'}
#' @export

getData<-function(setup,startval){
  out=list()
  NPP=numeric()
  NEE=numeric()
  WTD=numeric()
  autotr_resp=numeric()
  output<-read.csv(paste(setup$runDir,"/output/outmo.txt",sep=""),sep="",header=F,skip = 1)
  output<-output[startval:(nrow(output)-4),]
  outlist=numeric()

  if("NEE" %in% setup$type){
    for(i in 1:nrow(output)){
      NPP[i]<-(sum(output[i,4],output[i,8],output[i,12],output[i,16],output[i,20]))
      autotr_resp[i]<-sum(output[i,23:25])
      NEE[i]<- (-1*(NPP[i]-autotr_resp[i]))
    }
    outlist=cbind(outlist,NEE)
  }

  if("WTD" %in% setup$type){
    for(i in 1:nrow(output)){
      WTD[i]<-sum(-1*(output[i,26]/1000))
    }
    outlist=cbind(outlist,WTD)
  }

  if("autotr_resp" %in% setup$type){
    for(i in 1:nrow(output)){
      autotr_resp[i]<-sum(output[i,23:25])
    }
    outlist=cbind(outlist,autotr_resp)
  }

  if("NPP" %in% setup$type){
    for(i in 1:nrow(output)){
      NPP[i]<-(sum(output[i,4],output[i,8],output[i,12],output[i,16],output[i,20]))
    }
    outlist=cbind(outlist,NPP)
  }


  for (l in 1:ncol(outlist)){
  out[l]<-list(outlist[,l])
  }
  names(out) <- colnames(outlist)

  return(out)
}
