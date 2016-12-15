rm(list=ls())

library(NUCOMBog)
library(BayesianTools)
# library(Rmpi)
setwd("~/")

numCores=1
iterations=1e6
numFolders=1
nseq=10
# clustertype="SOCK"
# MPI_server=FALSE
# proposalScale=0.5#0.3
# resampling=F

setup_SMC<- setupNUCOM(mainDir="/home/jeroen/Desktop/MERBLEUE_long_term_2/",climate="Dataset_1766-2013.txt",environment="Env_Mer_Bleue.txt",inival="Inival_Mer_Bleue_low_biomass.txt",start=1766,end=2013,type=c("NEE","WTD"),numFolders=numFolders,separate = F,startval=2797,parallel = F)
setwd(setup_SMC[[1]]$mainDir)
data<-read.csv("input/NEE_WTD_GPP_MERBLEUE_1999_2013.csv",sep="\t",as.is=T)
data<-data[2:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA

source(file = "/home/jeroen/NUCOMBog/code_notforpackage/likelihoodParallel_new.R")
source(file = "/home/jeroen/NUCOMBog/code_notforpackage/likelihood_nucom.R")
source(file = "/home/jeroen/NUCOMBog/code_notforpackage/likelihoodsingle_new.R")
source(file = "/home/jeroen/NUCOMBog/code_notforpackage/MarginalPlot2.R")

source(file = "/home/jeroen/NUCOMBog/code_notforpackage/test_DREAMzs_03102016.R")

priorrange <- data.frame(min=min, max = max, row.names = names)
date<-Sys.Date()

save.image("~/Desktop/MERBLEUE_long_term/DREAMzs_sdNEE_30_10_1e6i_WTD0_1_NORMAL_CLIM_LOWBIOMASS.RData")
# 
# pdf(paste("marginalplot_scaled_Low_Biomass",date,".pdf",sep=""))
# marginalPlot2(out2,bounds = priorrange)
# dev.off()
#
# pdf(paste("marginalplot_unscaled_Low_Biomass",date,".pdf",sep=""))
# marginalPlot2(out2)
# dev.off()
#
# pdf(paste("correlationplot_Low_Biomass",date,".pdf",sep=""),width=200,height = 200)
# correlationPlot(out2)
# dev.off()

# save(out2,file=paste("out_",date,".rData",sep=""))
#
# unlink("folder*",recursive = T,force = T)
# mpi.quit()
