
library(NUCOMBog)
library(BayesianTools)
dev.off()
matrix_outc<-as.matrix(test_smc_nodecomp)
transmatrix_outc<-t(matrix_outc)
names <- c("gram_Kext","gram_MaxGr","gram_MortFrLvmsleaf","gram_SLA","eric_KExt","eric_MaxGr","eric_SLA","eric_WLOpt1","humm_CAllocFrshoot","humm_MaxGr","humm_MortFrAcroshoot","humm_TMaxGr","humm_TOpt1Gr","humm_TOpt2Gr","lawn_CAllocFrshoot","lawn_MaxGr","lawn_MortFrAcroshoot","lawn_TMaxGr","lawn_TOpt1Gr","lawn_TOpt2Gr","holl_CAllocFrshoot","holl_MaxGr","holl_MortFrAcroshoot","holl_TMaxGr","holl_TOpt1Gr","holl_TOpt2Gr","sd_NEE","sd_WTD")
values<-c(0.5,70,0.08,0.012,0.8,60,0.012,100,1,45,0.04,20,14,17,1,50,0.04,20,14,17,1,60,0.08,20,10,17,1,1)
meanvalues<-NULL


pdf("SMC_test25_11_2015_1.pdf",width=200,height = 200)
correlationPlot(transmatrix_outc)
dev.off()

pdf("SMC_test_hist2.pdf",width=200,height = 200)
par(mfrow=c(5,6))
for (i in 1:ncol(transmatrix_outc)){
  hist(transmatrix_outc[,i],main = names[i])
  abline(v=mean(transmatrix_outc[,i]),col=2) #mean values:red
  abline(v=values[i],col=3) # original value: green
  readline(prompt="Press [enter] to continue")
  meanvalues[i]<-mean(transmatrix_outc[,i])
}
dev.off()
par(mfrow=c(1,1))





outcome=list()
setup_SMC<-setup(mainDir="/home/jeroen/test_package/",climate="clim_1999-2013_measured.txt",environment="Env_Mer_Bleue_1999_2013.txt",inival="Inival_Mer_Bleue.txt",start=1999,end=2013,type=c("NEE","WTD"),parallel = F,separate = F)
data<-read.csv("input/NEE_WTD_GPP_MERBLEUE_1999_2013.csv",sep="\t",as.is=T)
data<-data[2:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA

optim<-data.frame(names,meanvalues)
names(optim)<-c("names","values")
a<-runnucom(setup = setup_SMC, parameters = optim)

plot(a$NEE,data$NEE)
abline(0,1,col=2)
fitNEE<-summary(lm(a$NEE~data$NEE))
legend("topright",legend=bquote(italic(R)^2 == .(format(fitNEE$r.squared,digits = 4))))

plot(a$WTD*100,data$WTD)
abline(0,1,col=2)
fitwtd<-summary(lm(a$WTD*100 ~  data$WTD))
legend("topright",legend=bquote(italic(R)^2 == .(format(fitwtd$r.squared,digits = 4))))

for(i in 1:100){
  print(i)
  j<-sample(1:10000, 1,replace=F)
  newparameters<-data.frame(names,test_smc_nodecomp[,j])
  names(newparameters)<-c("names","values")
  newparameters$names<-as.character(newparameters$names)
  outcome[[i]]<-runnucom(setup = setup_SMC, parameters = newparameters)
}

for(i in 1:length(outcome)){
  plot(outcome[[i]]$NEE,ylim=c(-80,60),col=i,type="l",lty=i)
  par(new=T)
}
points(data$NEE)
par(new=F)


for(i in 1:length(outcome)){
  plot(outcome[[i]]$WTD*100,ylim=c(-80,0),col=i,type="l",lty=i)
  par(new=T)
}
points(data$WTD)
par(new=F)
