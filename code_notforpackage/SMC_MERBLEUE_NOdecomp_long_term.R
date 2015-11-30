library(NUCOMBog)
# library(BayesianTools)


setup_SMC<-setup(mainDir="/home/jeroen/MERBLEUE_long_term/",climate="Dataset_1939-2013.txt",environment="Env_Mer_Bleue.txt",inival="Inival_Mer_Bleue.txt",start=1939,end=2013,type=c("NEE","WTD"),numFolders=100,separate = F,startval=721)
setwd(setup_SMC$runParameters[[1]]$mainDir)
data<-read.csv("input/NEE_WTD_GPP_MERBLEUE_1999_2013.csv",sep="\t",as.is=T)
data<-data[2:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA

names <- c("gram_Kext","gram_MaxGr","gram_MortFrLvmsleaf","gram_SLA","eric_KExt","eric_MaxGr","eric_SLA","eric_WLOpt1","humm_CAllocFrshoot","humm_MaxGr","humm_MortFrAcroshoot","humm_TMaxGr","humm_TOpt1Gr","humm_TOpt2Gr","lawn_CAllocFrshoot","lawn_MaxGr","lawn_MortFrAcroshoot","lawn_TMaxGr","lawn_TOpt1Gr","lawn_TOpt2Gr","holl_CAllocFrshoot","holl_MaxGr","holl_MortFrAcroshoot","holl_TMaxGr","holl_TOpt1Gr","holl_TOpt2Gr","sd_NEE1","sd_NEE2","sd_WTD1","sd_WTD2")
values<-c(0.5,70,0.08,0.012,0.8,60,0.012,100,1,45,0.04,20,14,17,1,50,0.04,20,14,17,1,60,0.08,20,10,17,1,1,1,1)
scale<-values/values
min<-   rep(0.1,length(names))*scale
max<-   rep(5,length(names))*scale


a<-matrix(runif(length(setup_SMC$runParameters)*length(names),min=min,max=max),nrow = length(names))


parind_norm<-data.frame(names,a)
par<-a*values
parind<-data.frame(names,par)
names(parind_norm)<-c("names",rep("values",ncol(a)))
names(parind)<-c("names",rep("values",ncol(a)))
parind_norm$names<-as.character(parind_norm$names)
parind$names<-as.character(parind$names)

priortest2<-function(x) {
  sum(dunif(x,min=(min*values),max=max(max*values),log=T))
}


test_smc_nodecomp_long_term<-smc_sampler(likelihood = likelihoodParallel,prior =priortest2,clustertype = "SOCK",numCores = 1,initialParticles = par,setup=setup_SMC, iterations =10, resampling = T, proposal = NULL, parallel="external",scaled=F,Logtype="corrected")

save(test_smc_nodecomp_long_term,file="test_smc_nodecomp_longterm_30112015.rData")
