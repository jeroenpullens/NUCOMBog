#'@title Function to retrieve data from the monthly output file created by NUCOMBog
#'
#'@author Jeroen Pullens
#'
#'@param WD Working Directory
#'@param type Data to be retrieved, integrated are "NEE" and "WTD"
#'
#'@examples
#'\dontrun{
#'getData(WD="~/nucom",type = c("NEE","WTD"))
#'}


getData<-function(WD,type){
  out=list()
  NPP=numeric()
  NEE=numeric()
  WTD=numeric()
  autotr_resp=numeric()
  output<-read.csv(paste(WD,"/output/outmo.txt",sep=""),sep="",header=F,skip = 1)
  output<-output[1:(nrow(output)-4),]

  if("NEE" %in% type){
    for(i in 1:nrow(output)){
      NPP[i]<-(sum(output[i,4],output[i,8],output[i,12],output[i,16],output[i,20]))
      autotr_resp[i]<-sum(output[i,23:37])
      NEE[i]<-NPP[i]-autotr_resp[i]
    }
  }

  if("WTD" %in% type){
    for(i in 1:nrow(output)){
      WTD[i]<-sum(output[i,38])
    }
  }
  out<-list(x=NEE,y=WTD)
  names(out) <- c("NEE","WTD")

  return(out)
}
