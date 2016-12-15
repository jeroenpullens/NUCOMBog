
# library(NUCOMBog)
# library(BayesianTools)

names <- c("gram_KExt","gram_MaxGr","gram_MortFrLvmsleaf","gram_SLA","eric_KExt","eric_MaxGr","eric_MortFrLvmsleaf","eric_SLA","eric_WLOpt1","humm_CAllocFrshoot","humm_MaxGr","humm_MortFrAcroshoot","humm_TMaxGr","humm_TOpt1Gr","humm_TOpt2Gr","lawn_CAllocFrshoot","lawn_MaxGr","lawn_MortFrAcroshoot","lawn_TMaxGr","lawn_TOpt1Gr","lawn_TOpt2Gr","holl_CAllocFrshoot","holl_MaxGr","holl_MortFrAcroshoot","holl_TMaxGr","holl_TOpt1Gr","holl_TOpt2Gr","sd_NEE1","sd_NEE2","sd_WTD1")
values<-c(0.5,70,0.08,0.012,0.8,60,0.08,0.012,100,1,45,0.04,20,14,17,1,50,0.04,20,14,17,1,60,0.08,20,10,17,1,1,0.1)
min<-   0.1*values
max<-  c(2,5,5,2,1.25,5,5,2,5,5,5,5,3,4.29,3.53,5,5,5,3,4.29,3.53,5,5,5,3,6,3.53,30,30,5)*values
# 
# names <- c("gram_KExt","sd_NEE1","sd_NEE2","sd_WTD1")
# values<-c(0.5,1,1,1)
# min<-   0.1*values
# max<-  c(2,5,5,5)*values
originalvalues<-values
# values<-values/values



bayesianSetup <- createBayesianSetup(likelihood = likelihoodsingle_new,lower = min, upper = max,parallel = T)
settings <- list(initialParticles = numFolders, iterations = iterations,nseq=nseq)
# ptm <- proc.time()
out2 <- runMCMC(bayesianSetup = bayesianSetup, sampler = "DREAMzs", settings = settings)
# proc.time() - ptm
# # dev.off()
# priorrange <- data.frame(min=min, max = max, row.names = names)
# marginalPlot2(mat=out2$particles,bounds = priorrange)
#
# x11()
# correlationPlot(out2)
# dev.off()

