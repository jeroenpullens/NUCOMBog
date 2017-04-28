library(plyr)
library(hydroGOF)
options(scipen=9999)
date<-Sys.Date()
a<-out2

data$WTD<-data$WTD/100
gelmanDiagnostics(a)
map<-MAP(a)
mapvalues<- map$parametersMAP

parameters<-data.frame(names,mapvalues)
names(parameters)<-c("names","values")

setup_SMC[[1]]$type <-c("NEE","WTD","hetero_resp","NPP")

out<-runNUCOM(setup = setup_SMC,parameters = parameters)

pdf(paste("NEE",date,"MVT.pdf",sep=""))
plotTimeSeries(observed = data$NEE,predicted = out$NEE)
abline(h=0,col="lightgray")
dev.off()

pdf(paste("NEE_1vs1",date,"MVT.pdf",sep=""))
plot(data$NEE,out$NEE,xlim=c(min(data$NEE,out$NEE,na.rm=T),max(data$NEE,out$NEE,na.rm=T)),ylim=c(min(data$NEE,out$NEE,na.rm=T),max(data$NEE,out$NEE,na.rm=T)))
summary(lm(out$NEE~data$NEE))
abline(0,1,col="red")
NSE(sim = out$NEE,obs = data$NEE)
rmse(sim = out$NEE,obs = data$NEE)
dev.off()

pdf("NEE_cumsumMVT.pdf")
plot(cumsum(out$NEE),col=2,ylim=c(-2000,1000))
par(new=T)
plot(cumsum(data$NEE),ylim=c(-2000,1000))
par(new=F)
dev.off()

pdf(paste("WTD",date,"MVT.pdf",sep=""))
plotTimeSeries(observed = data$WTD,predicted = out$WTD)
abline(h=0,col="lightgray")
dev.off()


pdf(paste("WTD_1vs1",date,"MVT.pdf",sep=""))
plot(data$WTD,out$WTD,xlim=c(min(data$WTD,out$WTD,na.rm=T),max(data$WTD,out$WTD,na.rm=T)),ylim=c(min(data$WTD,out$WTD,na.rm=T),max(data$WTD,out$WTD,na.rm=T)))
summary(lm(out$WTD~data$WTD))
abline(0,1,col="red")
NSE(sim = out$WTD,obs = data$WTD)
rmse(sim = out$WTD,obs = data$WTD)
dev.off()

codaObject = getSample(out2, coda = F,thin=5000)
codaObject<-codaObject[1:200,]
outcome<-NULL
for(i in 1:nrow(codaObject)){
  print(i)
  newparameters<-data.frame(names,codaObject[i,])
  names(newparameters)<-c("names","values")
  newparameters$names<-as.character(newparameters$names)
  outcome[[i]]<-runNUCOM(setup = setup_SMC, parameters = newparameters)
}

pdf("cumsum_NEEMVT.pdf")
for(i in 1:length(outcome)){
  plot(cumsum(outcome[[i]]$NEE),ylim=c(-2000,100),col="lightgray",type="l")
par(new=T)
}
plot(cumsum(data$NEE),ylim=c(-2000,100))
par(new=F)
dev.off()


minimum<-min(data$NEE,out$NEE,na.rm=T)
maximum<-max(data$NEE,out$NEE,na.rm=T)
pdf(paste("NEE",date,"_allMVT.pdf",sep=""))
mar.default <- c(5,4,4,2) + 0.1
par(mar = mar.default + c(0, 1, 0, 0)) 
for(i in 1:length(outcome)){
  plot(outcome[[i]]$NEE,ylim=c(minimum,maximum),col="lightgray",type="l",xlab="",ylab="",xaxt="n",yaxt="n",bty="n")
  par(new=T)
}
points(data$NEE,col=2,type="p")
par(new=T)
plot(out$NEE,ylim=c(minimum,maximum),col="black",type="l",main=paste(length(outcome)," random distributions"),xlab="Months",ylab=expression("Net Ecosystem Exchange" ~ (gC/m^{2}/month)))
par(new=F)
legend("bottomleft",legend=c("MAP","ensemble","data"),lty = c(1,1,NA),pch = c(NA,NA,1),col =c(1,"lightgray",2),horiz=T)
box()
dev.off()


minimum<-min(out$WTD,data$WTD,na.rm=T)
maximum<-max(out$WTD,data$WTD,na.rm=T)
pdf(paste("WTD",date,"_allMVT.pdf",sep=""))
mar.default <- c(5,4,4,2) + 0.1
par(mar = mar.default + c(0, 1, 0, 0)) 
for(i in 1:length(outcome)){
  plot(outcome[[i]]$WTD,ylim=c(minimum,maximum),col="lightgray",type="l",xlab="",ylab="",xaxt="n",yaxt="n",bty="n")
  par(new=T)
}
points(data$WTD,col=2,type="p")
par(new=T)
plot(out$WTD,ylim=c(minimum,maximum),col="black",type="l",main=paste(length(outcome)," random distributions"),xlab="Months",ylab="Water table depth (m)")
par(new=F)
box()
dev.off()

plot(out$hetero_resp,type="l")
plot(out$NPP,type="l")

maximum<-round_any(max(out$NPP),10)
pdf(paste("hetero_NPP",date,"MVT.pdf",sep=""))
plot(out$hetero_resp,type="l",ylim=c(0,maximum))
par(new=T)
plot(out$NPP,type="l",ylim=c(0,maximum),col=2)
par(new=F)
legend("topleft",legend = c("hetero_resp","NPP"),col = c(1,2),lty = 1)
dev.off()

