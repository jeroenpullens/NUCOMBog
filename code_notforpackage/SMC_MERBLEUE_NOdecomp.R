library(NUCOMBog)
# library(BayesianTools)


setup_SMC<-setupNUCOM(mainDir="/home/jeroen/test_package/",climate="clim_1999-2013_measured.txt",environment="Env_Mer_Bleue_1999_2013.txt",inival="Inival_Mer_Bleue.txt",start=1999,end=2013,type=c("NEE","WTD"),numFolders=10,separate = F,startval = 1)
setwd(setup_SMC$runParameters[[1]]$mainDir)
data<-read.csv("input/NEE_WTD_GPP_MERBLEUE_1999_2013.csv",sep="\t",as.is=T)
data<-data[2:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA

# names <- c("gram_Kext","gram_MaxGr","gram_MortFrLvmsleaf","gram_SLA","eric_KExt","eric_MaxGr","eric_SLA","eric_WLOpt1","humm_CAllocFrshoot","humm_MaxGr","humm_MortFrAcroshoot","humm_TMaxGr","humm_TOpt1Gr","humm_TOpt2Gr","lawn_CAllocFrshoot","lawn_MaxGr","lawn_MortFrAcroshoot","lawn_TMaxGr","lawn_TOpt1Gr","lawn_TOpt2Gr","holl_CAllocFrshoot","holl_MaxGr","holl_MortFrAcroshoot","holl_TMaxGr","holl_TOpt1Gr","holl_TOpt2Gr","sd_NEE1","sd_WTD")
# values<-c(0.5,70,0.08,0.012,0.8,60,0.012,100,1,45,0.04,20,14,17,1,50,0.04,20,14,17,1,60,0.08,20,10,17,1,1)
names <- c("gram_MaxGr","eric_MaxGr","humm_MaxGr","lawn_MaxGr","holl_MaxGr","sd_NEE1","sd_NEE2","sd_WTD1")
values<-c(70,60,45,50,60,1,1,1)
min<-   0.1*values
max<-   5*values

a<-matrix(runif(length(setup_SMC$runParameters)*length(names),min=min,max=max),nrow = length(names))

parind<-data.frame(names,a)
names(parind)<-c("names",rep("values",ncol(a)))
parind$names<-as.character(parind$names)

prior<-function(x) {
    sum(dunif(x,min=(min),max=(max),log=T))
}


proposal<-function(x){
  rnorm(length(x),mean=x,sd=values*0.2)
}


test_smc_nodecomp<-smc_sampler_mod(likelihood = likelihoodParallel,prior =prior,clustertype = "SOCK",numCores = 1,initialParticles = a,setup=setup_SMC, iterations =2, resampling = T, proposal = proposal, parallel="external",scaled=F,Logtype="corrected")

# save(test_smc_nodecomp,file="test_smc_nodecomp_25112015.rData")


