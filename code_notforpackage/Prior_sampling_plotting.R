rm(list=ls())

library(NUCOMBog)
library(BayesianTools)
# library(Rmpi)
setwd("~/")

setup_SMC<- setupNUCOM(mainDir="/home/jeroen/Desktop/IRELAND/",climate="CLIM_IRELAND_1766-2013_orig.txt",environment="Env_IRELAND_staticNdep.txt",inival="inival_IRELAND_centuries.txt",start=1900,end=2012,type=c("NEE","WTD","hetero_resp","NPP"),numFolders=numFolders,separate = F,startval=1237,parallel = F)
setwd(setup_SMC[[1]]$mainDir)
data<-read.csv("input/NEE_WTD_glencar_2003-2012_cut.txt",sep="\t",as.is=T)
# data<-data[2:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA

names <- c("gram_KExt","gram_MaxGr","gram_MortFrLvmsleaf","gram_SLA","eric_KExt","eric_MaxGr","eric_MortFrLvmsleaf","eric_SLA","eric_WLOpt1","humm_CAllocFrshoot","humm_MaxGr","humm_MortFrAcroshoot","humm_TMaxGr","humm_TOpt1Gr","humm_TOpt2Gr","lawn_CAllocFrshoot","lawn_MaxGr","lawn_MortFrAcroshoot","lawn_TMaxGr","lawn_TOpt1Gr","lawn_TOpt2Gr","holl_CAllocFrshoot","holl_MaxGr","holl_MortFrAcroshoot","holl_TMaxGr","holl_TOpt1Gr","holl_TOpt2Gr","sd_NEE1","sd_NEE2","sd_WTD1")
values<-c(0.5,70,0.08,0.012,0.8,60,0.04,0.012,300,1,45,0.04,25,14,18,1,50,0.04,25,14,18,1,60,0.08,25,10,18,1,1,0.1)
min<-   0.1*values
max<-  c(2,5,5,2,1.25,5,5,2,1.67,5,5,5,1.4,1.4,2.2,5,5,5,1.4,1.4,2.2,5,5,5,1.4,1.4,2.2,30,30,5)*values



outprior<-NULL

pb<-txtProgressBar(min = 0,max = 10000,style=3)
for(i in 1:10000){
    parameters<-data.frame(names,as.data.frame(runif(30,min=min,max=max)))
    names(parameters)<-c("names","values")
    # parameters<-parameters[1:27,]
outprior[[i]]<-runNUCOM(setup=setup_SMC,parameters = parameters)
setTxtProgressBar(pb, i)
}
close(pb)

save(outprior,file="outprior_10000.Rdata")

pdf("NEE_prior_10000.pdf")
for(i in 1:length(outprior)){
  plot(outprior[[i]]$NEE,ylim=c(-60,25),col="lightgray",type="l")
  par(new=T)
}
points(data$NEE,col=2,type="l")
par(new=F)
dev.off()

pdf("WTD_prior_10000.pdf")
for(i in 1:length(outprior)){
  plot(outprior[[i]]$WTD,ylim=c(-0.3,0.1),col="lightgray",type="l")
  par(new=T)
}
points(data$WTD/100,col=2,type="l")
par(new=F)
dev.off()


pdf("hetero_resp_prior_10000.pdf")
for(i in 1:length(outprior)){
   plot(outprior[[i]]$hetero_resp,ylim=c(0,150),col="lightgray",type="l")
   par(new=T)
}
dev.off()

pdf("npp_10000.pdf")
for(i in 1:length(outprior)){
  plot(outprior[[i]]$NPP,ylim=c(0,150),col="lightgray",type="l")
  par(new=T)
}
dev.off()
# {}