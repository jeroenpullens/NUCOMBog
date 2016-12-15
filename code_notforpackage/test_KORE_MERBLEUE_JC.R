library(BayesianTools)
library(NUCOMBog)
#library(Rmpi)
setwd("~/")

getwd()
numCores=5
iterations=150
numFolders=30
clustertype="SOCK"
proposalScale=0.3

#MPI_SERVER=TRUE

setup_SMC<- setupNUCOM(mainDir="/home/jeroen/Desktop/MERBLEUE_long_term/",climate="MERBLEUE_RANDOM_1766_2012.txt",environment="Env_Mer_Bleue.txt",inival="Inival_Mer_Bleue.txt",start=1766,end=2013,type=c("NEE","WTD"),numFolders=numFolders,separate = F,startval=2797,parallel = T)
setwd(setup_SMC$runParameter[[1]]$mainDir)
getwd()
data<-read.csv("input/NEE_WTD_GPP_MERBLEUE_1999_2013.csv",sep="\t",as.is=T)
data<-data[5:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA

source(file = "/home/jeroen/NUCOMBog/code_notforpackage/likelihoodParallel_new.R")
source(file = "/home/jeroen/NUCOMBog/code_notforpackage/likelihood_nucom.R")
source(file = "/home/jeroen/NUCOMBog/code_notforpackage/likelihoodsingle_new.R")
source(file = "/home/jeroen/NUCOMBog/code_notforpackage/MarginalPlot2.R")

source(file = "/home/jeroen/NUCOMBog/code_notforpackage/test_SMC_05072016.R")

priorrange <- data.frame(min=min, max = max, row.names = names)
date<-Sys.Date()

save(out2,file=paste("out_",date,".rData",sep=""))

# pdf(paste("marginalplot_scaled_",date,".pdf",sep=""))
# marginalPlot2(out2,bounds = priorrange)
# dev.off()
# 
# pdf(paste("marginalplot_unscaled_",date,".pdf",sep=""))
# marginalPlot2(out2)
# dev.off()
# 
# pdf(paste("correlationplot_",date,".pdf",sep=""),width=200,height = 200)
# correlationPlot(out2)
# dev.off()

unlink("folder*",recursive=TRUE)
