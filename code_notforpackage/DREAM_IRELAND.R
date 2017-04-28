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

setup_SMC<- setupNUCOM(mainDir="/home/jeroen/IRELAND/",climate="CLIM_IRELAND_1766-2013_orig.txt",environment="Env_IRELAND_Ndep_measured.txt",inival="inival_IRELAND.txt",start=1766,end=2012,type=c("NEE","WTD"),numFolders=numFolders,separate = F,startval=2845,parallel = F)
setwd(setup_SMC[[1]]$mainDir)
data<-read.csv("input/NEE_WTD_glencar_2003-2012.txt",sep="\t",as.is=T)
# data<-data[2:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA

source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/likelihoodParallel_new.R")
source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/likelihood_nucom2_mvtnorm.R")
source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/likelihoodsingle_new.R")
source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/MarginalPlot2.R")

source(file = "/home/jeroen/Desktop/nucom/code_notforpackage/DEzs_sdNEE.R")

save.image("/home/jeroen/IRELAND/DEzs_17072017_IRELAND_prec_temp_evap_10e6_soil_air_MVT.Rdata")
priorrange <- data.frame(min=min, max = max, row.names = names)
date<-Sys.Date()


pdf(paste("marginalplot_airsoil_scaled_cut_",date,".pdf",sep=""))
marginalPlot2(out2,bounds = priorrange)
dev.off()

pdf(paste("marginalplot_airsoil_unscaled_cut_",date,".pdf",sep=""))
marginalPlot2(out2)
dev.off()

pdf(paste("correlationplot_airsoil_cut_",date,".pdf",sep=""),width=200,height = 200)
correlationPlot(out2)
dev.off()

pdf(paste("traceplot_soil_airtemp_",date,".pdf",sep=""))
tracePlot(out2,parametersOnly=FALSE)
dev.off()

pdf(paste("traceplot_soil_airtemp_ndep_measured_thin_500_",date,".pdf",sep=""))
tracePlot(out2,parametersOnly=FALSE,thin = 500)
dev.off()
#
# save(out2,file=paste("out_",date,".rData",sep=""))
#
# unlink("folder*",recursive = T,force = T)
# mpi.quit()
