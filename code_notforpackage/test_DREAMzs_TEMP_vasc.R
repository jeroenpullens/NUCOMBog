# library(NUCOMBog)
# library(BayesianTools)

names<-c("gram_KExt","gram_MaxGr","gram_MortFrLvmsleaf","gram_SLA","gram_TOpt1Gr","gram_TOpt2Gr","eric_KExt","eric_MaxGr","eric_MortFrLvmsleaf","eric_SLA","eric_Topt1Gr","eric_Topt2Gr","humm_CAllocFrshoot","humm_MaxGr","humm_MortFrAcroshoot","lawn_CAllocFrshoot","lawn_MaxGr","lawn_MortFrAcroshoot","holl_CAllocFrshoot","holl_MaxGr","holl_MortFrAcroshoot","sd_NEE1","sd_NEE2","sd_WTD1")
values<-c(0.5,70,0.08,0.012,12,20,0.8,60,0.08,0.012,14,20,1,45,0.04,1,50,0.04,1,60,0.08,1,1,0.1)
min<-c(0.1,0.1,0.1,0.1,0.333333333333333,0.5,0.1,0.1,0.1,0.1,0.333333333333333,0.5,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1)*values
max<-c(2,5,5,2,1.25,1.25,1.25,5,5,2,1.25,1.25,5,5,5,5,5,5,5,5,5,30,30,5)*values
# 
# names <- c("gram_KExt","sd_NEE1","sd_NEE2","sd_WTD1")
# values<-c(0.5,1,1,1)
# min<-   0.1*values
# max<-  c(2,5,5,5)*values
originalvalues<-values
# values<-values/values



bayesianSetup <- createBayesianSetup(likelihood = likelihoodsingle_new,lower = min, upper = max)#,parallel = "external")
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

