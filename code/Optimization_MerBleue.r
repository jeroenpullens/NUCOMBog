#optim
#24-9-2015
rm(list=ls())
graphics.off()
require("DEoptim")

WD<-"/home/jeroen/nucom/"
setwd(WD)
niter=50
measured_data<-read.csv("data/NEE_WTD_GPP_MERBLEUE_1999_2013.csv",sep="\t",as.is=T)
measured_data<-measured_data[2:nrow(measured_data),]
measured_data<-as.data.frame(lapply(measured_data,as.numeric))
measured_data[measured_data==-9999]<-NA
options(scipen=999)

names <- c("gram_Kext","gram_MaxGr","gram_MortFrLvmsleaf","gram_SLA","eric_KExt","eric_MaxGr","eric_SLA","eric_WLOpt1","humm_CAllocFrshoot","humm_MaxGr","humm_MortFrAcroshoot","humm_TMaxGr","humm_TOpt1Gr","humm_TOpt2Gr","lawn_CAllocFrshoot","lawn_MaxGr","lawn_MortFrAcroshoot","lawn_TMaxGr","lawn_TOpt1Gr","lawn_TOpt2Gr","holl_CAllocFrshoot","holl_MaxGr","holl_MortFrAcroshoot","holl_TMaxGr","holl_TOpt1Gr","holl_TOpt2Gr","sd_GPP","sd_WTD")
values<-c(0.5,70,0.08,0.012,0.8,60,0.012,100,1,45,0.04,20,14,17,1,50,0.04,20,14,17,1,60,0.08,20,10,17,1,1)
min<-   0.8*values
max<-   1.2*values
parind<-data.frame(names,values,min,max)
parind$names<-as.character(parind$names)
out<-numeric()
likelihood_GPP<-numeric()
likelihood_WT<-numeric()

source("code/make_filenames.r")
source("code/make_param_file_subset.r")
source("code/runOptimization.r")

#standardize the min/max and values. In the model function the 'x' is again multiplied with 'values'
norm<-values/values
min<-min/values
max<-max/values

runnucom_optimization(norm)

set.seed(1234)
outDEoptim<-DEoptim(fn=runnucom_optimization,lower=min,upper=max,control = list(itermax=niter))
# from Vignette DEoptim: The algorithm stops after some set number of generations, or after the objective function
# value associated with the best member has been reduced below some set threshold, or if it is
# unable to reduce the best member by a certain value over over set number of iterations.

#default: itermax: 200
#NP: 50 Number of parents
#CR: 0.5 Crossover probability
#F: 0.8  Stepsize

pdf(paste("Merbleue_optim_",niter,".pdf",sep=""))
plot(outDEoptim, plot.type = "bestvalit")
dev.off()
#plot(outDEoptim)

save(outDEoptim,file=paste("outDEoptim_Merbleu_",niter,".Rdata",sep=""))


#---- After DEoptim
values_optim<-outDEoptim$optim$bestmem*values

source("code/runnucom.r")
optim_output<-runnucom(values_optim)
pdf("optim_output_vs_measured_data.pdf")
plot(optim_output,measured_data$GEP)
abline(0,1,col=2)
dev.off()

pdf("optim_output_&_measured_data.pdf")
plot(optim_output,type="b",ylim=c(0,max(optim_output)))
par(new=T)
plot(measured_data$GEP,type="b",col=2,ylim=c(0,max(optim_output)))
dev.off()

optim_output

