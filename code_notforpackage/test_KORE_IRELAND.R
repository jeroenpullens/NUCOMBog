library(BayesianTools)
library(NUCOMBog)
library(Rmpi)
setwd("~/")

getwd()
numCores=8
iterations=10
numFolders=1000000
clustertype="SOCK"
proposalScale=0.3

#MPI_SERVER=TRUE

setup_SMC<- setupNUCOM(mainDir="/fem0/keu_pullens/IRELAND/",climate="CLIM_IRELAND_1766-2013_orig.txt",environment="Env_IRELAND_staticNdep.txt",inival="inival_IRELAND_centuries.txt",start=1766,end=2012,type=c("NEE","WTD"),numFolders=numFolders,separate = F,startval=2845,parallel = T)
setwd(setup_SMC$runParameter[[1]]$mainDir)
getwd()
data<-read.csv("input/NEE_WTD_glencar_2003-2012.txt",sep="\t")
data<-data[5:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA




source(file = "/fem0/keu_pullens/code_notforpackage/likelihoodParallel_new.R")
source(file = "/fem0/keu_pullens/code_notforpackage/likelihood_nucom.R")
source(file = "/fem0/keu_pullens/code_notforpackage/likelihoodsingle_new.R")
source(file = "/fem0/keu_pullens/code_notforpackage/MarginalPlot2.R")

source(file = "/fem0/keu_pullens/code_notforpackage/test_SMC_05072016.R")

priorrange <- data.frame(min=min, max = max, row.names = names)
date<-Sys.Date()

save(out2,file=paste("out_",date,".rData",sep=""))

pdf(paste("marginalplot_scaled_",date,".pdf",sep=""))
marginalPlot2(out2,bounds = priorrange)
dev.off()

pdf(paste("marginalplot_unscaled_",date,".pdf",sep=""))
marginalPlot2(out2)
dev.off()

pdf(paste("correlationplot_",date,".pdf",sep=""),width=200,height = 200)
correlationPlot(out2)
dev.off()

unlink("folder*",recursive=TRUE)
