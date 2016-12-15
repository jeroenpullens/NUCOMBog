# dev.off()
rm(list = ls())
library(NUCOMBog)
library(BayesianTools)
setwd("~/")

numCores=2
iterations=500
numFolders=10
nseq=10
clustertype="SOCK"
# MPI_server=FALSE
# proposalScale=0.5#0.3
# resampling=F

setup_SMC <- setupNUCOM(mainDir = "/home/jeroen/Desktop/NUCOM_ITALY/", climate = "clim_1766_2016.txt",environment = "Env_ITALY.txt",inival = "Inival_ITALY.txt",start = 1766,end = 2015,startval = 2953,type = c("NEE","WTD"),parallel = F)

setwd(setup_SMC[[1]]$mainDir)
data<-read.csv("input/NEE_WTD_ITALY_2012_2016.csv",sep="\t",as.is=T)
data<-data[2:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA


source(file = "/home/jeroen/NUCOMBog/code_notforpackage/likelihoodParallel_new.R")
source(file = "/home/jeroen/NUCOMBog/code_notforpackage/likelihood_nucom.R")
source(file = "/home/jeroen/NUCOMBog/code_notforpackage/likelihoodsingle_new.R")
source(file = "/home/jeroen/NUCOMBog/code_notforpackage/MarginalPlot2.R")

source(file = "/home/jeroen/NUCOMBog/code_notforpackage/test_DREAMzs_03102016_parallel.R")

priorrange <- data.frame(min=min, max = max, row.names = names)
date<-Sys.Date()

save.image("~/Desktop/NUCOM_ITALY/DREAMzs_sdNEE_30_10_1e6i_WTD0_1_1766_2014_ITALY_parallel.RData")


# pdf(paste("marginalplot_scaled_ITALY_",date,".pdf",sep=""))
# marginalPlot2(out2,bounds = priorrange)
# dev.off()
# 
# pdf(paste("marginalplot_unscaled_ITALY_",date,".pdf",sep=""))
# marginalPlot2(out2)
# dev.off()
# 
# pdf(paste("correlationplot_ITALY_",date,".pdf",sep=""),width=200,height = 200)
# correlationPlot(out2)
# dev.off()

