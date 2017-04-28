rm(list=ls())

library(NUCOMBog)
library(BayesianTools)
# library(Rmpi)
setwd("~/")
# set.seed(11)
numCores=1
iterations=1e4
numFolders=1
nseq=10
# clustertype="SOCK"
# MPI_server=FALSE
# proposalScale=0.5#0.3
# resampling=F

setup_SMC<- setupNUCOM(mainDir = "/home/jeroen/MERBLEUE_long_term_temp_TEST/", climate = "MERBLEUE_RANDOM_2temp_1766_2013.txt",environment = "Env_Mer_Bleue_ndep_measured.txt",inival = "Inival_Mer_Bleue.txt",start=1766,end=2013,type=c("NEE","WTD","hetero_resp","NPP"),numFolders=numFolders,separate = F,startval=2797,parallel = F)
setwd(setup_SMC[[1]]$mainDir)
data<-read.csv("input/NEE_WTD_GPP_MERBLEUE_1999_2013.csv",sep="\t",as.is=T)
data<-data[2:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA

source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/likelihoodParallel_new.R")
source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/likelihood_nucom2_mvtnorm.R")
source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/likelihoodsingle_new.R")
source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/MarginalPlot2.R")

source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/DEzs_sdNEE.R")

priorrange <- data.frame(min=min, max = max, row.names = names)
date<-Sys.Date()

save.image("~/MERBLEUE_long_term_TEST/DEzs_1e6i_soil_airtemp_ndep_measured_1766_1707_WTL_sdNEE_NEW_dnorm_1503.RData")

pdf(paste("marginalplot_scaled_soil_airtemp_ndep_measured_",date,".pdf",sep=""))
marginalPlot2(out2,bounds = priorrange)
dev.off()

pdf(paste("marginalplot_unscaled_soil_airtemp_ndep_measured_",date,".pdf",sep=""))
marginalPlot2(out2)
dev.off()

pdf(paste("correlationplot_soil_airtemp_ndep_measured_",date,".pdf",sep=""),width=200,height = 200)
correlationPlot(out2)
dev.off()

pdf(paste("traceplot_soil_airtemp_ndep_measured_",date,".pdf",sep=""))
tracePlot(out2,parametersOnly=FALSE)
dev.off()

pdf(paste("traceplot_soil_airtemp_ndep_measured_thin_500_",date,".pdf",sep=""))
tracePlot(out2,parametersOnly=FALSE,thin = 500)
dev.off()


# save(out2,file=paste("out_",date,".rData",sep=""))
#
# unlink("folder*",recursive = T,force = T)
# mpi.quit()
