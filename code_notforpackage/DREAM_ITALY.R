 # dev.off()
rm(list = ls())
library(NUCOMBog)
library(BayesianTools)
setwd("~/")

numCores=1
iterations=1e6
numFolders=1
nseq=10
# clustertype="SOCK"
# MPI_server=FALSE
# proposalScale=0.5#0.3
# resampling=F

setup_SMC <- setupNUCOM(mainDir = "/home/jeroen/NUCOM_ITALY/", climate = "clim_1766_2016.txt",environment = "Env_ITALY_ndep_measured.txt",inival = "Inival_ITALY.txt",start = 1766,end = 2016,startval = 2953,type = c("NEE","WTD"))
setwd(setup_SMC[[1]]$mainDir)
data<-read.csv("input/NEE_WTD_ITALY_2012_2016.csv",sep="\t",as.is=T)
data<-data[2:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA


source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/likelihoodParallel_new.R")
source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/likelihood_nucom2.R")
source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/likelihoodsingle_new.R")
source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/MarginalPlot2.R")

source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/DEzs_sdNEE.R")

priorrange <- data.frame(min=min, max = max, row.names = names)
date<-Sys.Date()

save.image("~/NUCOM_ITALY/DEzs_ITALY_1e6_2016_airsoil_meas_ndep_WTL.RData")


pdf(paste("marginalplot_scaled_ITALY_",date,".pdf",sep=""))
marginalPlot2(out2,bounds = priorrange)
dev.off()

pdf(paste("marginalplot_unscaled_ITALY_",date,".pdf",sep=""))
marginalPlot2(out2)
dev.off()

pdf(paste("correlationplot_ITALY_",date,".pdf",sep=""),width=200,height = 200)
correlationPlot(out2)
dev.off()

pdf(paste("traceplot_soil_airtemp_ndep_measured_",date,".pdf",sep=""))
tracePlot(out2,parametersOnly=FALSE)
dev.off()

pdf(paste("traceplot_soil_airtemp_ndep_measured_thin_500_",date,".pdf",sep=""))
tracePlot(out2,parametersOnly=FALSE,thin = 500)
dev.off()