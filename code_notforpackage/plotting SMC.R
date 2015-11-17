
library(NUCOMBog)
library(BayesianTools)
dev.off()
matrix_outc<-as.matrix(test_smc_nodecomp)
transmatrix_outc<-t(matrix_outc)
names <- c("gram_Kext","gram_MaxGr","gram_MortFrLvmsleaf","gram_SLA","eric_KExt","eric_MaxGr","eric_SLA","eric_WLOpt1","humm_CAllocFrshoot","humm_MaxGr","humm_MortFrAcroshoot","humm_TMaxGr","humm_TOpt1Gr","humm_TOpt2Gr","lawn_CAllocFrshoot","lawn_MaxGr","lawn_MortFrAcroshoot","lawn_TMaxGr","lawn_TOpt1Gr","lawn_TOpt2Gr","holl_CAllocFrshoot","holl_MaxGr","holl_MortFrAcroshoot","holl_TMaxGr","holl_TOpt1Gr","holl_TOpt2Gr","sd_NEE","sd_WTD")




pdf("SMC_MERBLEUE_p1000_i10_rT_newgetdata_NOdecomp.pdf",width=200,height = 200)
correlationPlot(transmatrix_outc)
dev.off()

pdf("SMC_MERBLEUE_p1000_i10_rT_newgetdata_NOdecomp_hist.pdf",width=200,height = 200)
par(mfrow=c(5,6))
for (i in 1:ncol(transmatrix_outc)){
  hist(transmatrix_outc[,i],nclass=50)
  abline(v=mean(transmatrix_outc[,i]),col=2)

}
dev.off()
par(mfrow=c(1,1))

outcome=list()
setup_SMC<-setup(mainDir="/home/jeroen/test_package/",climate="clim_1999-2013_measured.txt",environment="Env_Mer_Bleue_1999_2013.txt",inival="Inival_Mer_Bleue.txt",start=1999,end=2013,type=c("NEE","WTD"),parallel = F,separate = F)
data<-read.csv("/home/jeroen/test_package/data/NEE_WTD_GPP_MERBLEUE_1999_2013.csv")
for(i in 1:10){
  print(i)
  newparameters<-data.frame(names,test_smc_nodecomp[i])
  names(newparameters)<-c("names","values")
  newparameters$names<-as.character(newparameters$names)
  outcome[[i]]<-runnucom(setup = setup_SMC, parameters = newparameters)
}

for(i in 1:length(outcome)){
  plot(outcome[[i]]$NEE,ylim=c(-80,60),col=i,type="l",lty=i)
  par(new=T)
}
