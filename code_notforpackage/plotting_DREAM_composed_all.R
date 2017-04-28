library(plyr)
library(hydroGOF)
options(scipen=9999)
date<-Sys.Date()
a<-out2

gelmanDiagnostics(a)
map<-MAP(a)
mapvalues<- map$parametersMAP

parameters<-data.frame(names,mapvalues)
names(parameters)<-c("names","values")

setup_SMC_canada[[1]]$type <-c("NEE","WTD","hetero_resp","NPP")
setup_SMC_ireland[[1]]$type <-c("NEE","WTD","hetero_resp","NPP")
setup_SMC_italy[[1]]$type <-c("NEE","WTD","hetero_resp","NPP")


out_canada<-runNUCOM(setup = setup_SMC_canada,parameters = parameters)
out_ireland<-runNUCOM(setup = setup_SMC_ireland,parameters = parameters)
out_italy<-runNUCOM(setup = setup_SMC_italy,parameters = parameters)

data_canada$WTD<-data_canada$WTD/100
data_ireland$WTD<-data_ireland$WTD/100
data_italy$WTD<-data_italy$WTD/100

setwd("~/ALL_SITES_AIRSOIL/")
##### CANADA
#####
pdf(paste("NEE_canada",date,".pdf",sep=""))
plotTimeSeries(observed = data_canada$NEE,predicted = out_canada$NEE)
abline(h=0,col="lightgray")
dev.off()

pdf(paste("NEE_1vs1_canada",date,".pdf",sep=""))
plot(data_canada$NEE,out_canada$NEE,xlim=c(min(data_canada$NEE,out_canada$NEE,na.rm=T),max(data_canada$NEE,out_canada$NEE,na.rm=T)),ylim=c(min(data_canada$NEE,out_canada$NEE,na.rm=T),max(data_canada$NEE,out_canada$NEE,na.rm=T)))
summary(lm(out_canada$NEE~data_canada$NEE))
abline(0,1,col="red")
NSE(sim = out_canada$NEE,obs = data_canada$NEE)
rmse(sim = out_canada$NEE,obs = data_canada$NEE)
dev.off()

pdf("NEE_cumsum_canada.pdf")
plot(cumsum(out_canada$NEE),col=2,ylim=c(-2000,1000))
par(new=T)
plot(cumsum(data_canada$NEE),ylim=c(-2000,1000))
par(new=F)
dev.off()


pdf(paste("WTD_canada",date,".pdf",sep=""))
plotTimeSeries(observed = data_canada$WTD,predicted = out_canada$WTD)
abline(h=0,col="lightgray")
dev.off()

pdf(paste("WTD_canada_1vs1",date,".pdf",sep=""))
plot(data_canada$WTD,out_canada$WTD,xlim=c(min(data_canada$WTD,out_canada$WTD,na.rm=T),max(data_canada$WTD,out_canada$WTD,na.rm=T)),ylim=c(min(data_canada$WTD,out_canada$WTD,na.rm=T),max(data_canada$WTD,out_canada$WTD,na.rm=T)))
summary(lm(out_canada$WTD~data_canada$WTD))
abline(0,1,col="red")
NSE(sim = out_canada$WTD,obs = data_canada$WTD)
rmse(sim = out_canada$WTD,obs = data_canada$WTD)
dev.off()


#####

##### IRELAND
#####
pdf(paste("NEE_ireland",date,".pdf",sep=""))
plotTimeSeries(observed = data_ireland$NEE,predicted = out_ireland$NEE)
abline(h=0,col="lightgray")
dev.off()

pdf(paste("NEE_1vs1_ireland",date,".pdf",sep=""))
plot(data_ireland$NEE,out_ireland$NEE,xlim=c(min(data_ireland$NEE,out_ireland$NEE,na.rm=T),max(data_ireland$NEE,out_ireland$NEE,na.rm=T)),ylim=c(min(data_ireland$NEE,out_ireland$NEE,na.rm=T),max(data_ireland$NEE,out_ireland$NEE,na.rm=T)))
summary(lm(out_ireland$NEE~data_ireland$NEE))
abline(0,1,col="red")
NSE(sim = out_ireland$NEE,obs = data_ireland$NEE)
rmse(sim = out_ireland$NEE,obs = data_ireland$NEE)
dev.off()

pdf("NEE_cumsum_ireland.pdf")
plot(cumsum(out_ireland$NEE),col=2,ylim=c(-2000,1000))
par(new=T)
plot(cumsum(data_ireland$NEE),ylim=c(-2000,1000))
par(new=F)
dev.off()

pdf(paste("WTD_ireland",date,".pdf",sep=""))
plotTimeSeries(observed = data_ireland$WTD,predicted = out_ireland$WTD)
abline(h=0,col="lightgray")
dev.off()

pdf(paste("WTD_ireland_1vs1",date,".pdf",sep=""))
plot(data_ireland$WTD,out_ireland$WTD,xlim=c(min(data_ireland$WTD,out_ireland$WTD,na.rm=T),max(data_ireland$WTD,out_ireland$WTD,na.rm=T)),ylim=c(min(data_ireland$WTD,out_ireland$WTD,na.rm=T),max(data_ireland$WTD,out_ireland$WTD,na.rm=T)))
summary(lm(out_ireland$WTD~data_ireland$WTD))
abline(0,1,col="red")
NSE(sim = out_ireland$WTD,obs = data_ireland$WTD)
rmse(sim = out_ireland$WTD,obs = data_ireland$WTD)
dev.off()
#####

##### ITALY
#####
pdf(paste("NEE_italy",date,".pdf",sep=""))
plotTimeSeries(observed = data_italy$NEE,predicted = out_italy$NEE)
abline(h=0,col="lightgray")
dev.off()

pdf(paste("NEE_1vs1_italy",date,".pdf",sep=""))
plot(data_italy$NEE,out_italy$NEE,xlim=c(min(data_italy$NEE,out_italy$NEE,na.rm=T),max(data_italy$NEE,out_italy$NEE,na.rm=T)),ylim=c(min(data_italy$NEE,out_italy$NEE,na.rm=T),max(data_italy$NEE,out_italy$NEE,na.rm=T)))
summary(lm(out_italy$NEE~data_italy$NEE))
abline(0,1,col="red")
NSE(sim = out_italy$NEE,obs = data_italy$NEE)
rmse(sim = out_italy$NEE,obs = data_italy$NEE)
dev.off()

pdf("NEE_cumsum_italy.pdf")
plot(cumsum(out_italy$NEE),col=2,ylim=c(-2000,1000))
par(new=T)
plot(cumsum(data_italy$NEE),ylim=c(-2000,1000))
par(new=F)
dev.off()


pdf(paste("WTD_italy",date,".pdf",sep=""))
plotTimeSeries(observed = data_italy$WTD,predicted = out_italy$WTD)
abline(h=0,col="lightgray")
dev.off()

pdf(paste("WTD_italy_1vs1",date,".pdf",sep=""))
plot(data_italy$WTD,out_italy$WTD,xlim=c(min(data_italy$WTD,out_italy$WTD,na.rm=T),max(data_italy$WTD,out_italy$WTD,na.rm=T)),ylim=c(min(data_italy$WTD,out_italy$WTD,na.rm=T),max(data_italy$WTD,out_italy$WTD,na.rm=T)))
summary(lm(out_italy$WTD~data_italy$WTD))
abline(0,1,col="red")
NSE(sim = out_italy$WTD,obs = data_italy$WTD)
rmse(sim = out_italy$WTD,obs = data_italy$WTD)
dev.off()
#####

codaObject = getSample(out2, coda = F,thin=5000)
codaObject<-codaObject[1:200,]
outcome_canada<-NULL
outcome_ireland<-NULL
outcome_italy<-NULL
for(i in 1:nrow(codaObject)){
  print(i)
  newparameters<-data.frame(names,codaObject[i,])
  names(newparameters)<-c("names","values")
  newparameters$names<-as.character(newparameters$names)
  outcome_canada[[i]]<-runNUCOM(setup = setup_SMC_canada, parameters = newparameters)
  outcome_ireland[[i]]<-runNUCOM(setup = setup_SMC_ireland, parameters = newparameters)
  outcome_italy[[i]]<-runNUCOM(setup = setup_SMC_italy, parameters = newparameters)
}
setwd("~/ALL_SITES_AIRSOIL/")

## CANADA
minimum<- -100
maximum<- 70
pdf(paste("NEE_canada_",date,"_all.pdf",sep=""))
mar.default <- c(5,4,4,2) + 0.1
par(mar = mar.default + c(0, 1, 0, 0)) 
for(i in 1:length(outcome_canada)){
  plot(outcome_canada[[i]]$NEE,ylim=c(minimum,maximum),col="lightgray",type="l",xlab="",ylab="",xaxt="n",yaxt="n",bty="n")
  par(new=T)
}
points(data_canada$NEE,col=2,type="p")
par(new=T)
plot(out_canada$NEE,ylim=c(minimum,maximum),col="black",type="l",main=paste(length(outcome_canada)," random distributions"),xlab="Months",ylab=expression("Net Ecosystem Exchange" ~ (gC/m^{2}/month)))
par(new=F)
box()
dev.off()

minimum<-min(out_canada$WTD,data_canada$WTD,na.rm=T)
maximum<-max(out_canada$WTD,data_canada$WTD,na.rm=T)
pdf(paste("WTD_canada_",date,"_all.pdf",sep=""))
mar.default <- c(5,4,4,2) + 0.1
par(mar = mar.default + c(0, 1, 0, 0)) 
for(i in 1:length(outcome_canada)){
  plot(outcome_canada[[i]]$WTD,ylim=c(-0.8,0.1),col="lightgray",type="l",xlab="",ylab="",xaxt="n",yaxt="n",bty="n")
  par(new=T)
}
points(data_canada$WTD,col=2,type="p")
par(new=T)
plot(out_canada$WTD,ylim=c(-0.8,0.1),col="black",type="l",main=paste(length(outcome_canada)," random distributions"),xlab="Months",ylab="Water table depth (m)")
par(new=F)
box()
dev.off()

plot(out_canada$hetero_resp,type="l")
plot(out_canada$NPP,type="l")

maximum<-round_any(max(out_canada$NPP),10)
pdf(paste("hetero_NPP_canada_",date,".pdf",sep=""))
mar.default <- c(5,4,4,2) + 0.1
par(mar = mar.default + c(0, 1, 0, 0)) 
plot(out_canada$hetero_resp,type="l",ylim=c(0,maximum))
par(new=T)
plot(out_canada$NPP,type="l",ylim=c(0,maximum),col=2)
par(new=F)
legend("topleft",legend = c("hetero_resp","NPP"),col = c(1,2),lty = 1)
dev.off()

##IRELAND

minimum<- -150
maximum<- 30
pdf(paste("NEE_ireland_",date,"_all.pdf",sep=""))
mar.default <- c(5,4,4,2) + 0.1
par(mar = mar.default + c(0, 1, 0, 0)) 
for(i in 1:length(outcome_ireland)){
  plot(outcome_ireland[[i]]$NEE,ylim=c(minimum,maximum),col="lightgray",type="l",xlab="",ylab="",xaxt="n",yaxt="n",bty="n")
  par(new=T)
}
points(data_ireland$NEE,col=2,type="p")
par(new=T)
plot(out_ireland$NEE,ylim=c(minimum,maximum),col="black",type="l",main=paste(length(outcome_ireland)," random distributions"),xlab="Months",ylab=expression("Net Ecosystem Exchange" ~ (gC/m^{2}/month)))
par(new=F)
box()
dev.off()

minimum<- -0.5
maximum<- 0.1
pdf(paste("WTD_ireland_",date,"_all.pdf",sep=""))
mar.default <- c(5,4,4,2) + 0.1
par(mar = mar.default + c(0, 1, 0, 0)) 
for(i in 1:length(outcome_ireland)){
  plot(outcome_ireland[[i]]$WTD,ylim=c(minimum,maximum),col="lightgray",type="l",xlab="",ylab="",xaxt="n",yaxt="n",bty="n")
  par(new=T)
}
points(data_ireland$WTD,col=2,type="p")
par(new=T)
plot(out_ireland$WTD,ylim=c(minimum,maximum),col="black",type="l",main=paste(length(outcome_ireland)," random distributions"),xlab="Months",ylab="Water table depth (m)")
par(new=F)
box()
dev.off()

plot(out_ireland$hetero_resp,type="l")
plot(out_ireland$NPP,type="l")

maximum<-round_any(max(out_ireland$NPP),10)
pdf(paste("hetero_NPP_ireland_",date,".pdf",sep=""))
mar.default <- c(5,4,4,2) + 0.1
par(mar = mar.default + c(0, 1, 0, 0)) 
plot(out_ireland$hetero_resp,type="l",ylim=c(0,maximum))
par(new=T)
plot(out_ireland$NPP,type="l",ylim=c(0,maximum),col=2)
par(new=F)
legend("topleft",legend = c("hetero_resp","NPP"),col = c(1,2),lty = 1)
dev.off()

## ITALY
minimum<- -250
maximum<- 200
pdf(paste("NEE_italy_",date,"_all.pdf",sep=""))
mar.default <- c(5,4,4,2) + 0.1
par(mar = mar.default + c(0, 1, 0, 0)) 
for(i in 1:length(outcome_italy)){
  plot(outcome_italy[[i]]$NEE,ylim=c(minimum,maximum),col="lightgray",type="l",xlab="",ylab="",xaxt="n",yaxt="n",bty="n")
  par(new=T)
}
points(data_italy$NEE,col=2,type="p")
par(new=T)
plot(out_italy$NEE,ylim=c(minimum,maximum),col="black",type="l",main=paste(length(outcome_italy)," random distributions"),xlab="Months",ylab=expression("Net Ecosystem Exchange" ~ (gC/m^{2}/month)))
par(new=F)
box()
dev.off()

minimum<- -1
maximum<- 0.2
pdf(paste("WTD_italy_",date,"_all.pdf",sep=""))
mar.default <- c(5,4,4,2) + 0.1
par(mar = mar.default + c(0, 1, 0, 0)) 
for(i in 1:length(outcome_italy)){
  plot(outcome_italy[[i]]$WTD,ylim=c(minimum,maximum),col="lightgray",type="l",xlab="",ylab="",xaxt="n",yaxt="n",bty="n")
  par(new=T)
}
points(data_italy$WTD,col=2,type="p")
par(new=T)
plot(out_italy$WTD,ylim=c(minimum,maximum),col="black",type="l",main=paste(length(outcome_italy)," random distributions"),xlab="Months",ylab="Water table depth (m)")
par(new=F)
box()
dev.off()

plot(out_italy$hetero_resp,type="l")
plot(out_italy$NPP,type="l")

maximum<-round_any(max(out_italy$NPP),10)
pdf(paste("hetero_NPP_italy_",date,".pdf",sep=""))
mar.default <- c(5,4,4,2) + 0.1
par(mar = mar.default + c(0, 1, 0, 0)) 
plot(out_italy$hetero_resp,type="l",ylim=c(0,maximum))
par(new=T)
plot(out_italy$NPP,type="l",ylim=c(0,maximum),col=2)
par(new=F)
legend("topleft",legend = c("hetero_resp","NPP"),col = c(1,2),lty = 1)
dev.off()
