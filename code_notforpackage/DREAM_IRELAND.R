rm(list=ls())

library(NUCOMBog)
library(BayesianTools)
# library(Rmpi)
setwd("~/")

numCores=1
iterations=1e4
numFolders=1
nseq=10
# clustertype="SOCK"
# MPI_server=FALSE
# proposalScale=0.5#0.3
# resampling=F

setup_SMC<- setupNUCOM(mainDir="/home/jeroen/Desktop/IRELAND/",climate="CLIM_IRELAND_1766-2013_orig.txt",environment="Env_IRELAND_staticNdep.txt",inival="inival_IRELAND_centuries.txt",start=1900,end=2012,type=c("NEE","WTD"),numFolders=numFolders,separate = F,startval=1237,parallel = F)
setwd(setup_SMC[[1]]$mainDir)
data<-read.csv("input/NEE_WTD_glencar_2003-2012_cut.txt",sep="\t",as.is=T)
# data<-data[2:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA

source(file = "/home/jeroen/NUCOMBog/code_notforpackage/likelihoodParallel_new.R")
source(file = "/home/jeroen/NUCOMBog/code_notforpackage/likelihood_nucom2.R")
source(file = "/home/jeroen/NUCOMBog/code_notforpackage/likelihoodsingle_new.R")
source(file = "/home/jeroen/NUCOMBog/code_notforpackage/MarginalPlot2.R")

source(file = "/home/jeroen/NUCOMBog/code_notforpackage/test_DREAMzs_03102016.R")

save.image("~/Desktop/IRELAND/DREAMzs_sdNEE_30_10_1e6i_WTD0_1_cut_nseq_10_dif_LL_WTD.RData")
priorrange <- data.frame(min=min, max = max, row.names = names)
date<-Sys.Date()
# 
# pdf(paste("marginalplot_scaled_cut_",date,".pdf",sep=""))
# marginalPlot2(out2,bounds = priorrange)
# dev.off()
# 
# pdf(paste("marginalplot_unscaled_cut_",date,".pdf",sep=""))
# marginalPlot2(out2)
# dev.off()
# 
# pdf(paste("correlationplot_cut_",date,".pdf",sep=""),width=200,height = 200)
# correlationPlot(out2)
# dev.off()
#
# save(out2,file=paste("out_",date,".rData",sep=""))
#
# unlink("folder*",recursive = T,force = T)
# mpi.quit()
