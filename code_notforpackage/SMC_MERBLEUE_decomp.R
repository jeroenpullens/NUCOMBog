library(NUCOMBog)
# library(BayesianTools)


setup_SMC<-setupNUCOM(mainDir="/home/jeroen/test_package/",climate="clim_1999-2013_measured.txt",environment="Env_Mer_Bleue_1999_2013.txt",inival="Inival_Mer_Bleue.txt",start=1999,end=2013,type=c("NEE","WTD"),numFolders=10,separate = F)
setwd(setup_SMC$runParameters[[1]]$mainDir)
data<-read.csv("input/NEE_WTD_GPP_MERBLEUE_1999_2013.csv",sep="\t",as.is=T)
data<-data[2:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA

names <- c("ToptDec","dec_param1above","dec_param2above","dec_param1below","dec_param2below","gram_Kext","gram_MaxGr","gram_MortFrLvmsleaf","gram_SLA","eric_KExt","eric_MaxGr","eric_SLA","eric_WLOpt1","humm_CAllocFrshoot","humm_MaxGr","humm_MortFrAcroshoot","humm_TMaxGr","humm_TOpt1Gr","humm_TOpt2Gr","lawn_CAllocFrshoot","lawn_MaxGr","lawn_MortFrAcroshoot","lawn_TMaxGr","lawn_TOpt1Gr","lawn_TOpt2Gr","holl_CAllocFrshoot","holl_MaxGr","holl_MortFrAcroshoot","holl_TMaxGr","holl_TOpt1Gr","holl_TOpt2Gr","sd_NEE","sd_WTD")
values<-c(37,-3.764,0.204,-1.882,0.102,0.5,70,0.08,0.012,0.8,60,0.012,100,1,45,0.04,20,14,17,1,50,0.04,20,14,17,1,60,0.08,20,10,17,1,1)
scale<-values/values
min<-   c(0.1,rep(0.1,32))*scale
max<-   c(1.5,rep(5,32))*scale


a<-matrix(runif(10*33,min=min,max=max),nrow = length(names))


parind_norm<-data.frame(names,a)
par<-a*values
parind<-data.frame(names,par)
names(parind_norm)<-c("names",rep("values",ncol(a)))
names(parind)<-c("names",rep("values",ncol(a)))
parind_norm$names<-as.character(parind_norm$names)
parind$names<-as.character(parind$names)


test_smc<-smc_sampler(likelihoodParallel,clustertype = "SOCK",numCores = 1,initialParticles = parind,setup=setup_SMC, iterations =1, resampling = F, proposal = NULL, parallel="external",parameters=parind_norm,scaled=T,originalvalues=parind)
save(test_smc,file="test_smc.Rdata")
