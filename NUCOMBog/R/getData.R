#'@title Function to retrieve data from the monthly output file created by NUCOMBog
#'
#'@author Jeroen Pullens
#'
#'@param WD Working Directory
#'@param type Data to be retrieved, integrated are "NEE","WTD","autotr_resp","NPP".
#'
#'The original model gives NPP back as output, the model has been changed to give Autotrophic respiration as output. In this way NEE can be calculated.
#'The model gives WTD in mm and negative means below ground level. by dividing it by 1000 the output is in meters and converted, that positive values mean water table depth.
#'
#'@examples
#'\dontrun{
#'getData(WD="~/nucom",type = c("NEE","WTD"))
#'}
#' @export



getData<-function(setup,startval=1){
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
