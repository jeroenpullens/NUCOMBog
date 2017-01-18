rm(list=ls())

library(NUCOMBog)
library(BayesianTools)
# library(Rmpi)
setwd("~/")

setup_SMC <- setupNUCOM(mainDir = "/home/jeroen/MERBLEUE_decomp/", climate = "MERBLEUE_RANDOM_soiltemp_1766_2013.txt",environment = "Env_Mer_Bleue.txt",inival = "Inival_Mer_Bleue.txt",start=1766,end=2013,startval=2797,type = c("NEE","WTD","hetero_resp","NPP"))
setwd(setup_SMC[[1]]$mainDir)
data<-read.csv("input/NEE_WTD_GPP_MERBLEUE_1999_2013.csv",sep="\t",as.is=T)
data<-data[2:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA


names <- c("gram_KExt","gram_MaxGr","gram_MortFrLvmsleaf","gram_SLA","gram_TOpt1Gr","gram_TOpt2Gr","gram_TmaxGr","eric_KExt","eric_MaxGr","eric_MortFrLvmsleaf","eric_SLA","eric_TOpt1Gr","eric_TOpt2Gr","eric_TmaxGr","eric_WLOpt1","humm_CAllocFrshoot","humm_MaxGr","humm_MortFrAcroshoot","humm_TMaxGr","humm_TOpt1Gr","humm_TOpt2Gr","lawn_CAllocFrshoot","lawn_MaxGr","lawn_MortFrAcroshoot","lawn_TMaxGr","lawn_TOpt1Gr","lawn_TOpt2Gr","holl_CAllocFrshoot","holl_MaxGr","holl_MortFrAcroshoot","holl_TMaxGr","holl_TOpt1Gr","holl_TOpt2Gr","sd_NEE1","sd_NEE2","sd_WTD1")
values<-c(0.5,70,0.08,0.012,12,20,25,0.8,60,0.04,0.012,5,14,25,300,1,45,0.04,25,14,18,1,50,0.04,25,14,18,1,60,0.08,25,10,18,1,1,0.1)
min<-   0.1*values
max<-  c(2,5,5,2,0.4,1.7,1.4,1.25,5,5,2,0.4,2.2,1.4,1.67,5,5,5,1.4,1.4,2.2,5,5,5,1.4,1.4,2.2,5,5,5,1.4,1.4,2.2,30,30,5)*values

# names <- c("gram_KExt","gram_MaxGr","gram_MortFrLvmsleaf","gram_SLA","eric_KExt","eric_MaxGr","eric_MortFrLvmsleaf","eric_SLA","eric_WLOpt1","humm_CAllocFrshoot","humm_MaxGr","humm_MortFrAcroshoot","humm_TMaxGr","humm_TOpt1Gr","humm_TOpt2Gr","lawn_CAllocFrshoot","lawn_MaxGr","lawn_MortFrAcroshoot","lawn_TMaxGr","lawn_TOpt1Gr","lawn_TOpt2Gr","holl_CAllocFrshoot","holl_MaxGr","holl_MortFrAcroshoot","holl_TMaxGr","holl_TOpt1Gr","holl_TOpt2Gr","sd_NEE1","sd_NEE2","sd_WTD1")
# values<-c(0.5,70,0.08,0.012,0.8,60,0.04,0.012,300,1,45,0.04,25,14,18,1,50,0.04,25,14,18,1,60,0.08,25,10,18,1,1,0.1)
# min<-   0.1*values
# max<-  c(2,5,5,2,1.25,5,5,2,1.67,5,5,5,1.4,1.4,2.2,5,5,5,1.4,1.4,2.2,5,5,5,1.4,1.4,2.2,30,30,5)*values

outprior<-NULL

pb<-txtProgressBar(min = 0,max = 1000,style=3)
for(i in 1:1000){
    parameters<-data.frame(names,as.data.frame(runif(36,min=min,max=max)))
    names(parameters)<-c("names","values")
    # parameters<-parameters[1:27,]
outprior[[i]]<-runNUCOM(setup=setup_SMC,parameters = parameters)
setTxtProgressBar(pb, i)
}
close(pb)

save.image(file="outprior_decomp_soiltemp_10000.Rdata")

pdf("NEE_prior_10000_soiltemp.pdf")
for(i in 1:length(outprior)){
  plot(outprior[[i]]$NEE,ylim=c(-60,60),col="lightgray",type="l")
  par(new=T)
}
points(data$NEE,col=2,type="l")
par(new=F)
dev.off()

pdf("WTD_prior_10000_soiltemp.pdf")
for(i in 1:length(outprior)){
  plot(outprior[[i]]$WTD,ylim=c(-0.7,0.1),col="lightgray",type="l")
  par(new=T)
}
points(data$WTD/100,col=2,type="l")
par(new=F)
dev.off()


pdf("hetero_resp_prior_10000_soiltemp.pdf")
for(i in 1:length(outprior)){
   plot(outprior[[i]]$hetero_resp,ylim=c(0,150),col="lightgray",type="l")
   par(new=T)
}
dev.off()

pdf("npp_10000_soiltemp.pdf")
for(i in 1:length(outprior)){
  plot(outprior[[i]]$NPP,ylim=c(0,150),col="lightgray",type="l")
  par(new=T)
}
dev.off()
# {}