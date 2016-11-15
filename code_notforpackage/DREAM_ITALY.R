dev.off()
rm(list = ls())
library(NUCOMBog)
library(BayesianTools)
setwd("~/")

numCores=1
iterations=1e4
numFolders=1
nseq=10
# clustertype="SOCK"
# MPI_server=FALSE
# proposalScale=0.5#0.3
# resampling=F

setup_SMC <- setupNUCOM(mainDir = "/home/jeroen/NUCOM_ITALY/", climate = "clim_2012_2039.txt",environment = "Env_ITALY.txt",inival = "Inival_ITALY.txt",start = 2012,end = 2014,type = c("NEE","WTD"))

setwd(setup_SMC[[1]]$mainDir)
data<-read.csv("input/NEE_WTD_ITALY_2012_2016_nieuw.csv",sep="\t",as.is=T)
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
