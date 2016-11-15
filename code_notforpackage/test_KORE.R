rm(list=ls())

library(NUCOMBog)
library(BayesianTools)
# library(Rmpi)
setwd("~/")

numCores=1
iterations=2000
numFolders=1
nseq=10
# clustertype="SOCK"
# MPI_server=FALSE
# proposalScale=0.5#0.3
# resampling=F

setup_SMC<- setupNUCOM(mainDir="/home/jeroen/MERBLEUE_long_term/",climate="Dataset_1939-2013.txt",environment="Env_Mer_Bleue.txt",inival="Inival_Mer_Bleue.txt",start=1939,end=2013,type=c("NEE","WTD"),numFolders=numFolders,separate = F,startval=721,parallel = F)
setwd(setup_SMC[[1]]$mainDir)
data<-read.csv("input/NEE_WTD_GPP_MERBLEUE_1999_2013.csv",sep="\t",as.is=T)
data<-data[2:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA

source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/likelihoodParallel_new.R")
source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/likelihood_nucom.R")
source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/likelihoodsingle_new.R")
source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/MarginalPlot2.R")

source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/test_DREAMzs_03102016.R")

priorrange <- data.frame(min=min, max = max, row.names = names)
date<-Sys.Date()

# pdf(paste("marginalplot_scaled_",date,".pdf",sep=""))
marginalPlot2(out2,bounds = priorrange)
# dev.off()
#
# pdf(paste("marginalplot_unscaled_",date,".pdf",sep=""))
# marginalPlot2(out2)
# dev.off()
#
# pdf(paste("correlationplot_",date,".pdf",sep=""),width=200,height = 200)
correlationPlot(out2)
# dev.off()
#
# save(out2,file=paste("out_",date,".rData",sep=""))
#
# unlink("folder*",recursive = T,force = T)
# mpi.quit()
