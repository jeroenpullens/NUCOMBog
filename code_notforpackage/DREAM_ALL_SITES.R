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

setup_SMC_ireland<- setupNUCOM(mainDir="/home/jeroen/IRELAND/",climate="CLIM_IRELAND_1766-2013_orig.txt",environment="Env_IRELAND_Ndep_measured.txt",inival="inival_IRELAND.txt",start=1766,end=2012,type=c("NEE","WTD"),numFolders=numFolders,separate = F,startval=2845,parallel = F)
setwd(setup_SMC_ireland[[1]]$mainDir)
data_ireland<-read.csv("input/NEE_WTD_glencar_2003-2012.txt",sep="\t",as.is=T)
# data<-data[2:nrow(data),]
data_ireland<-as.data.frame(lapply(data_ireland,as.numeric))
data_ireland[data_ireland==-9999]<-NA

setup_SMC_canada<- setupNUCOM(mainDir = "/home/jeroen/MERBLEUE_long_term_temp_TEST/", climate = "MERBLEUE_RANDOM_2temp_1766_2013.txt",environment = "Env_Mer_Bleue_ndep_measured.txt",inival = "Inival_Mer_Bleue.txt",start=1766,end=2013,type=c("NEE","WTD","hetero_resp","NPP"),numFolders=numFolders,separate = F,startval=2797,parallel = F)
setwd(setup_SMC_canada[[1]]$mainDir)
data_canada<-read.csv("input/NEE_WTD_GPP_MERBLEUE_1999_2013.csv",sep="\t",as.is=T)
data_canada<-data_canada[2:nrow(data_canada),]
data_canada<-as.data.frame(lapply(data_canada,as.numeric))
data_canada[data_canada==-9999]<-NA

setup_SMC_italy <- setupNUCOM(mainDir = "/home/jeroen/NUCOM_ITALY/", climate = "clim_1766_2016.txt",environment = "Env_ITALY_ndep_measured.txt",inival = "Inival_ITALY.txt",start = 1766,end = 2016,startval = 2953,type = c("NEE","WTD"))
setwd(setup_SMC_italy[[1]]$mainDir)
data_italy<-read.csv("input/NEE_WTD_ITALY_2012_2016.csv",sep="\t",as.is=T)
data_italy<-data_italy[2:nrow(data_italy),]
data_italy<-as.data.frame(lapply(data_italy,as.numeric))
data_italy[data_italy==-9999]<-NA

source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/likelihoodParallel_new.R")
source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/likelihood_nucom2.R")
source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/likelihoodsingle_all_sites.R")
source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/MarginalPlot2.R")

source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/test_DEzs_allsites.R")

priorrange <- data.frame(min=min, max = max, row.names = names)
date<-Sys.Date()

save.image("~/DEzs__airsoil_all_sites_10_6.RData")


# pdf(paste("marginalplot_scaled_ALL_",date,".pdf",sep=""))
# marginalPlot2(out2,bounds = priorrange)
# dev.off()
# 
# pdf(paste("marginalplot_unscaled_ALL_",date,".pdf",sep=""))
# marginalPlot2(out2)
# dev.off()
# 
# pdf(paste("correlationplot_ALL_",date,".pdf",sep=""),width=200,height = 200)
# correlationPlot(out2)
# dev.off()

