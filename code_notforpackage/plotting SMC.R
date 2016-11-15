
library(NUCOMBog)
library(BayesianTools)
dev.off()

# names <- c("gram_Kext","gram_MaxGr","gram_MortFrLvmsleaf","gram_SLA","eric_KExt","eric_MaxGr","eric_SLA","eric_WLOpt1","humm_CAllocFrshoot","humm_MaxGr","humm_MortFrAcroshoot","humm_TMaxGr","humm_TOpt1Gr","humm_TOpt2Gr","lawn_CAllocFrshoot","lawn_MaxGr","lawn_MortFrAcroshoot","lawn_TMaxGr","lawn_TOpt1Gr","lawn_TOpt2Gr","holl_CAllocFrshoot","holl_MaxGr","holl_MortFrAcroshoot","holl_TMaxGr","holl_TOpt1Gr","holl_TOpt2Gr","sd_NEE1","sd_NEE2","sd_WTD1","sd_WTD2")
# values<-c(0.5,70,0.08,0.012,0.8,60,0.012,100,1,45,0.04,20,14,17,1,50,0.04,20,14,17,1,60,0.08,20,10,17,1,1,1,1)
meanvalues<-NULL

prior <- data.frame(min=min, max = max, row.names = names)

particles=matrix(test_smc_nodecomp[1:80],ncol=8, byrow = T)
colnames(particles) = names
x11()
pdf("marginalplotsmc_nodecomp_longterm_corLL_NewPrior_03042016_1k_10i.pdf")
par(mar=c(5, 11, 4, 2) + 0.1)
marginalPlot(mat=particles, bounds = prior)
dev.off()

summary(particles)

pdf("correlationplot_smc_nodecomp_longterm_13042016_1k_10i_0.5proposal.pdf",width=200,height = 200)
pdf("test.pdf",width=200,height = 200)
correlationPlot(particles)
dev.off()

pdf("long_run07012016_hist2.pdf",width=200,height = 200)
par(mfrow=c(5,6))
for (i in 1:ncol(particles)){
  hist(particles[,i],main = names[i])
  abline(v=mean(particles[,i]),col=2) #mean values:red
  abline(v=values[i],col=3) # original value: green
  readline(prompt="Press [enter] to continue")
  meanvalues[i]<-mean(particles[,i])
}
dev.off()
par(mfrow=c(1,1))

###########################find minimum LL
LL=test_smc_nodecomp_long_term[300001:310000]
minimum<-which(LL==max(LL))

setup_SMC<-setupNUCOM(mainDir="/home/jeroen/MERBLEUE_long_term/",climate="Dataset_1939-2013.txt",environment="Env_Mer_Bleue.txt",inival="Inival_Mer_Bleue.txt",start=1939,end=2013,type=c("NEE","WTD","NPP","autotr_resp"),parallel = F,separate = F,startval=721)
data<-read.csv("input/NEE_WTD_GPP_MERBLEUE_1999_2013.csv",sep="\t",as.is=T)
data<-data[2:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA

parameters<-data.frame(names,particles[minimum[1],])
names(parameters)<-c("names","values")
setup_SMC[[1]]$type<-c("NEE","WTD","hetero_resp","NPP")
output<-runNUCOM(setup = setup_SMC, parameters = parameters)
# par(mfrow=c(2,1))
plotTimeSeries(observed = data$NEE,predicted = output$NEE)
plotTimeSeries(observed = data$WTD/100,predicted = output$WTD)
par(mfrow=c(1,1))

for (i in 1:ndata$new_WTDcol(particles)){
  parameters$values[i]<-mean(particles[,i])
}

###########################100 runs
outcome<-NULL
for(i in 1:100){
  print(i)
   j<-sample(1:100,1,replace=F)
   print(j)
  newparameters<-data.frame(names,particles[j,])
  names(newparameters)<-c("names","values")
  newparameters$names<-as.character(newparameters$names)
  outcome[[i]]<-runNUCOM(setup = setup_SMC, parameters = newparameters)
}

for(i in 1:length(outcome)){
  plot(outcome[[i]]$NEE,ylim=c(-60,25),col=i,type="l",lty=i)
  par(new=T)
}
points(data$NEE,col=2,type="l")
par(new=F)


for(i in 1:length(outcome)){
  plot(outcome[[i]]$WTD*100,ylim=c(-80,0),col=i,type="l",lty=i)
  par(new=T)
}
points(data$WTD,col=2,type="l")
par(new=F)

