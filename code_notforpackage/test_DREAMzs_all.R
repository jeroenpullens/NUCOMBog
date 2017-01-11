# library(NUCOMBog)
# library(BayesianTools)

values<-c(16,25,35,16,25,35,25,30,35,0.7,0.4,0.4,0.2,0.9,0.24,0.24,0.24,0.13,0.13,0.13,0.00004,0.00004,0.039,0.5,70,0.08,0.06,0.1,0.45,0.4,0.15,0.03,0.02,0.45,0.3,0.012,25,2,12,20,1000,-100,0,400,16,100,70,16,100,70,25,100,70,0.7,0.35,0.3,0.35,0.7,0.17,0.17,0.17,0.08,0.06,0.07,0.00004,0.00004,0.00004,0.8,60,0.04,0.01,0.04,0.45,0.25,0.3,0.022,0.014,0.25,0.1,0.012,25,5,14,20,600,50,100,300,9,20,40,0.7,1,1.4,0.02,0.02,0.00004,45,0.04,1,0.032,0.005,0.4,20,5,14,17,500,0,50,200,7,13,25,0.7,1,1.3,0.04,0.04,0.00004,50,0.04,1,0.036,0.006,0.4,20,3,14,17,350,0,50,150,5,15,30,0.7,1,1.2,0.08,0.08,0.00004,60,0.08,1,0.042,0.008,0.4,20,0,10,17,200,-100,0,50,1,1,0.1)
names<-c("gram_BDLvmsleaf","gram_BDLvmsstem","gram_BDLvmsroot","gram_BDAcroleaf","gram_BDAcrostem","gram_BDAcroroot","gram_BDCatoleaf","gram_BDCatostem","gram_BDCatoroot","gram_Beta","gram_CAllocFrleaf","gram_CAllocFrstem","gram_CAllocFrroot","gram_CropFc","gram_DecParLvmsleaf","gram_DecParLvmsstem","gram_DecParLvmsroot","gram_DecParAcroleaf","gram_DecParAcrostem","gram_DecParAcroroot","gram_DecParCatoleaf","gram_DecParCatostem","gram_DecParCatoroot","gram_KExt","gram_MaxGr","gram_MortFrLvmsleaf","gram_MortFrAcrostem","gram_MortFrCatoroot","gram_NAllocFrleaf","gram_NAllocFrstem","gram_NAllocFrroot","gram_NConcMax","gram_NconcMin","gram_ReallFrleaf","gram_ReallFrroot","gram_SLA","gram_TMaxGr","gram_TMinGr","gram_TOpt1Gr","gram_TOpt2Gr","gram_WLMax","gram_WLMin","gram_WLOpt1","gram_WLOpt2","eric_BDLvmsleaf","eric_BDLvmsstem","eric_BDLvmsroot","eric_BDAcroleaf","eric_BDAcrostem","eric_BDAcroroot","eric_BDCatoleaf","eric_BDCatostem","eric_BDCatoroot","eric_Beta","eric_CAllocFrleaf","eric_CAllocFrstem","eric_CAllocFrroot","eric_CropFc","eric_DecParLvmsleaf","eric_DecParLvmsstem","eric_DecParLvmsroot","eric_DecParAcroleaf","eric_DecParAcrostem","eric_DecParAcroroot","eric_DecParCatoleaf","eric_DecParCatostem","eric_DecParCatoroot","eric_KExt","eric_MaxGr","eric_MortFrLvmsleaf","eric_MortFrAcrostem","eric_MortFrAcroroot","eric_NAllocFrleaf","eric_NAllocFrstem","eric_NAllocFrroot","eric_NConcMax","eric_NconcMin","eric_ReallFrleaf","eric_ReallFrroot","eric_SLA","eric_TMaxGr","eric_TMinGr","eric_TOpt1Gr","eric_TOpt2Gr","eric_WLMax","eric_WLMin","eric_WLOpt1","eric_WLOpt2","humm_BDLvmsshoot","humm_BDAcroshoot","humm_BDCatoshoot","humm_Beta","humm_CAllocFrshoot","humm_CropFc","humm_DecParLvmsshoot","humm_DecParAcroshoot","humm_DecParCatoshoot","humm_MaxGr","humm_MortFrAcroshoot","humm_NAllocFrshoot","humm_NConcMax","humm_NConcMin","humm_ReallFrshoot","humm_TMaxGr","humm_TMinGr","humm_TOpt1Gr","humm_TOpt2Gr","humm_WLMax","humm_WLMin","humm_WLOpt1","humm_WLOpt2","lawn_BDLvmsshoot","lawn_BDAcroshoot","lawn_BDCatoshoot","lawn_Beta","lawn_CAllocFrshoot","lawn_CropFc","lawn_DecParLvmsshoot","lawn_DecParAcroshoot","lawn_DecParCatoshoot","lawn_MaxGr","lawn_MortFrAcroshoot","lawn_NAllocFrshoot","lawn_NConcMax","lawn_NConcMin","lawn_ReallFrshoot","lawn_TMaxGr","lawn_TMinGr","lawn_TOpt1Gr","lawn_TOpt2Gr","lawn_WLMax","lawn_WLMin","lawn_WLOpt1","lawn_WLOpt2","holl_BDLvmsshoot","holl_BDAcroshoot","holl_BDCatoshoot","holl_Beta","holl_CAllocFrshoot","holl_CropFc","holl_DecParLvmsshoot","holl_DecParAcroshoot","holl_DecParCatoshoot","holl_MaxGr","holl_MortFrAcroshoot","holl_NAllocFrshoot","holl_NConcMax","holl_NConcMin","holl_ReallFrshoot","holl_TMaxGr","holl_TMinGr","holl_TOpt1Gr","holl_TOpt2Gr","holl_WLMax","holl_WLMin","holl_WLOpt1","holl_WLOpt2","sd_NEE1","sd_NEE2","sd_WTD1")
min<-   c(rep(0.5,41),2,rep(0.5,112),2,0.5,0.5,0.1,0.1,0.1)*values
max<-  c(rep(2,41),0.5,rep(2,112),0.5,2,2,30,30,5)*values
for(i in 1:length(values)){
  if(min[i]==0){
    min[i]<- -100}
  if(max[i]==0){
    max[i] <- 100}
}
originalvalues<-values

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

