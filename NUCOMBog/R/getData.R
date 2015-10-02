out=list()
GPP=numeric()
WTD=numeric()
getData<-function(type){
  output<-read.csv(paste(WD,"/output/outmo.txt",sep=""),sep="",header=F,skip = 1)
  output<-output[1:(nrow(output)-4),]
  
  if("GPP" %in% type){
    for(i in 1:nrow(output)){
      GPP[i]<-sum(output[i,4],output[i,8],output[i,12],output[i,16],output[i,20])
    }
  }
  
  if("WTD" %in% type){
    for(i in 1:nrow(output)){
      WTD[i]<-sum(output[i,23])
    }
  }
  out<-list(x=GPP,y=WTD)
  names(out) <- c("GPP","WTD")
  
  return(out)
}