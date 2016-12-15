library(NUCOMBog)
# library(BayesianTools)

setup_SMC<- setupNUCOM(mainDir="/home/jeroen/Desktop/MERBLEUE_long_term/",climate="Dataset_1766-2013.txt",environment="Env_Mer_Bleue.txt",inival="Inival_Mer_Bleue.txt",start=1766,end=2013,type=c("NEE","WTD"),numFolders=10,separate = F,startval=2797,parallel=T)
setwd(setup_SMC$runParameters[[1]]$mainDir)
data<-read.csv("input/NEE_WTD_GPP_MERBLEUE_1999_2013.csv",sep="\t",as.is=T)
data<-data[2:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA

# big set
names <- c("gram_KExt","gram_MaxGr","gram_MortFrLvmsleaf","gram_SLA","eric_KExt","eric_MaxGr","eric_MortFrLvmsleaf","eric_SLA","eric_WLOpt1","humm_CAllocFrshoot","humm_MaxGr","humm_MortFrAcroshoot","humm_TMaxGr","humm_TOpt1Gr","humm_TOpt2Gr","lawn_CAllocFrshoot","lawn_MaxGr","lawn_MortFrAcroshoot","lawn_TMaxGr","lawn_TOpt1Gr","lawn_TOpt2Gr","holl_CAllocFrshoot","holl_MaxGr","holl_MortFrAcroshoot","holl_TMaxGr","holl_TOpt1Gr","holl_TOpt2Gr","sd_NEE1","sd_NEE2","sd_WTD1")
values<-c(0.5,70,0.08,0.012,0.8,60,0.08,0.012,100,1,45,0.04,20,14,17,1,50,0.04,20,14,17,1,60,0.08,20,10,17,1,1,0.1)
min<-   0.1*values
max<-  c(2,5,5,2,1.25,5,5,2,5,5,5,5,3,4.29,3.53,5,5,5,3,4.29,3.53,5,5,5,3,6,3.53,30,30,5)*values

# #NO calloc moss
# names<-c("gram_Kext","gram_MaxGr","gram_MortFrLvmsleaf","gram_SLA","eric_KExt","eric_MaxGr","eric_MortFrLvmsleaf","eric_SLA","eric_WLOpt1","humm_MaxGr","humm_MortFrAcroshoot","humm_TMaxGr","humm_TOpt1Gr","humm_TOpt2Gr","lawn_MaxGr","lawn_MortFrAcroshoot","lawn_TMaxGr","lawn_TOpt1Gr","lawn_TOpt2Gr","holl_MaxGr","holl_MortFrAcroshoot","holl_TMaxGr","holl_TOpt1Gr","holl_TOpt2Gr","sd_NEE1","sd_NEE2","sd_WTD1")
# values<-c(0.5,70,0.08,0.012,0.8,60,0.08,0.012,100,45,0.04,20,14,17,50,0.04,20,14,17,60,0.08,20,10,17,1,1,1)
# min<-   0.1*values
# max<-c(2,5,5,2,1.25,5,5,2,5,5,5,3,4.29,3.53,5,5,3,4.29,3.53,5,5,3,6,3.53,5,5,5)*values


#manual tuning
# names<-c("gram_Kext","gram_MaxGr","eric_KExt","eric_MaxGr","humm_MaxGr","lawn_MaxGr","holl_MaxGr","sd_NEE1","sd_NEE2","sd_WTD1")
# values<-c(0.5,70,0.8,60,45,50,60,1,1,1)
# min<-   0.1*values
# max<-c(2,5,1.25,5,5,5,5,5,5,5)*values




par<-matrix(runif(length(setup_SMC$runParameters)*length(names),min=min,max=max),nrow = length(names))

parind<-data.frame(names,par)
names(parind)<-c("names",rep("values",ncol(par)))
parind$names<-as.character(parind$names)

priortest2<-function(x) {
  sum(dunif(x,min=(min),max=(max),log=T))
}

proposal<-function(x){
   rnorm(length(x),mean=x,sd=values*0.5)
 }

test_smc_nodecomp_long_term<-smc_sampler_mod(likelihood = likelihoodParallel,prior =priortest2,clustertype = "SOCK",numCores = 1,initialParticles = par,setup=setup_SMC, iterations =1, resampling = T, proposal = proposal, parallel="external",scaled=F,Logtype="corrected")

# save(test_smc_nodecomp_long_term,file=paste("test_smc_nodecomp_longterm_basic_param_100k_10i_",Sys.Date(),".rData",sep=""))
save.image("~/Desktop/MERBLEUE_long_term/SMC_sdNEE_30_10_1e6i_WTD0_1_1766_2013.RData")

