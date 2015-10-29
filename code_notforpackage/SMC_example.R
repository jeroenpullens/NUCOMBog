library(NUCOMBog)
library(BayesianTools)

setup_SMC<-setup(mainDir="/home/jeroen/test_package/",climate="clim_1999-2013_measured.txt",environment="Env_Mer_Bleue_1999_2013.txt",inival="Inival_Mer_Bleue.txt",start=1999,end=2013,type=c("NEE","WTD"),numFolders=10)
data<-read.csv("input/NEE_WTD_GPP_MERBLEUE_1999_2013.csv",sep="\t",as.is=T)
data<-data[2:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA



names <- c("ToptDec","dec_param1above","dec_param2above","dec_param1below","dec_param2below","gram_Kext","gram_MaxGr","gram_MortFrLvmsleaf","gram_SLA","eric_KExt","eric_MaxGr","eric_SLA","eric_WLOpt1","humm_CAllocFrshoot","humm_MaxGr","humm_MortFrAcroshoot","humm_TMaxGr","humm_TOpt1Gr","humm_TOpt2Gr","lawn_CAllocFrshoot","lawn_MaxGr","lawn_MortFrAcroshoot","lawn_TMaxGr","lawn_TOpt1Gr","lawn_TOpt2Gr","holl_CAllocFrshoot","holl_MaxGr","holl_MortFrAcroshoot","holl_TMaxGr","holl_TOpt1Gr","holl_TOpt2Gr","sd_NEE","sd_WTD")
values<-c(37,3.764,0.204,1.882,0.102,0.5,70,0.08,0.012,0.8,60,0.012,100,1,45,0.04,20,14,17,1,50,0.04,20,14,17,1,60,0.08,20,10,17,1,1)
min<-   c(0.1,rep(0.1,32))*values
max<-   c(1.5,rep(5,32))*values

initialvalues<-matrix(rnorm(33,mean=values,sd=1),nrow = length(values))
parind<-data.frame(names,initialvalues)
parind$names<-as.character(parind$names)

smc_sampler(likelihood= likelihoodParallel(setup=setup_SMC,clustertype="SOCK",numCores=1,parameters = initialvalues), initialParticles =initialvalues, iterations =1, resampling = F, proposal = NULL, parallel=F)
# automaticMCMC(likelihood = likelihood_nucom,prior = NULL,startvalues = startvalues,maxiter = 10,steplength = 10,optimize = T)

