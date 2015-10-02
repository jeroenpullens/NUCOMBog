# make function to run modelMEE ----
runnucom<-function(x){
  make_param_file(x)
  system("./modelMEE")
  output<-read.csv(paste(WD,"output/outmo.txt",sep=""),sep="",header=F,skip = 1)
  output<-output[1:(nrow(output)-4),]
  out<-sum(output[,4],output[,8],output[,12],output[,16],output[,20])
  return(out)
}