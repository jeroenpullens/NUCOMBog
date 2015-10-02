# make function to run modelMEE ----
runnucom_optimization<-function(x){
  x<-x*values
  make_param_file(x)
  system("./modelMEE")
  output<-read.csv(paste(WD,"output/outmo.txt",sep=""),sep="",header=F,skip = 1)
  output<-output[1:(nrow(output)-4),]
  for(i in 1:nrow(output)){ #first row of output is empty and last 4 are filenames
    out[i]<-sum(output[i,4],output[i,8],output[i,12],output[i,16],output[i,20])
    likelihood_GPP[i]=dnorm(measured_data$GPP[i],mean=out[i],sd=x[27],log=T)
    likelihood_WT[i]=dnorm(measured_data$WTD[i],mean=output[i,23],sd=x[28],log=T)
  }
  sumll=sum(likelihood_GPP,likelihood_WT,na.rm = T)*-1
  return(sumll)
}