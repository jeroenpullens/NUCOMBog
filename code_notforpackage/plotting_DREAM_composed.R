library(plyr)
date<-Sys.Date()
a<-out2

gelmanDiagnostics(out2)
map<-MAP(a)
mapvalues<- map$parametersMAP

parameters<-data.frame(names,mapvalues)
names(parameters)<-c("names","values")

setup_SMC[[1]]$type <-c("NEE","WTD","hetero_resp","NPP")

out<-runNUCOM(setup = setup_SMC,parameters = parameters)

pdf(paste("NEE",date,".pdf",sep=""))
plotTimeSeries(observed = data$NEE,predicted = out$NEE)
abline(h=0,col="lightgray")
dev.off()

plot(cumsum(out$NEE),col=2,ylim=c(-1500,100))
par(new=T)
plot(cumsum(data$NEE),ylim=c(-1500,100))
par(new=F)

pdf(paste("WTD",date,".pdf",sep=""))
plotTimeSeries(observed = data$WTD/100,predicted = out$WTD)
abline(h=0,col="lightgray")
dev.off()

codaObject = getSample(out2, coda = F,thin=50)
outcome<-NULL
for(i in 1:nrow(codaObject)){
  print(i)
  newparameters<-data.frame(names,codaObject[i,])
  names(newparameters)<-c("names","values")
  newparameters$names<-as.character(newparameters$names)
  outcome[[i]]<-runNUCOM(setup = setup_SMC, parameters = newparameters)
}


minimum<-min(data$NEE,na.rm=T)
maximum<-max(data$NEE,na.rm=T)
pdf(paste("NEE",date,"_all.pdf",sep=""))
for(i in 1:length(outcome)){
  plot(outcome[[i]]$NEE,ylim=c(minimum,maximum),col="lightgray",type="l")
  par(new=T)
}
points(data$NEE,col=2,type="p")
par(new=T)
plot(out$NEE,ylim=c(minimum,maximum),col="black",type="l",main=length(outcome))
par(new=F)
dev.off()


minimum<-min(data$WTD/100,na.rm=T)
maximum<-max(data$WTD/100,na.rm=T)
pdf(paste("WTD",date,"_all.pdf",sep=""))
for(i in 1:length(outcome)){
  plot(outcome[[i]]$WTD,ylim=c(minimum,maximum),col="lightgray",type="l")
  par(new=T)
}
points(data$WTD/100,col=2,type="p")
par(new=T)
plot(out$WTD,ylim=c(minimum,maximum),col="black",type="l",main=length(outcome))
par(new=F)
dev.off()

plot(out$hetero_resp,type="l")
plot(out$NPP,type="l")


maximum<-round_any(max(out$NPP),10)
pdf(paste("hetero_NPP",date,".pdf",sep=""))
plot(out$hetero_resp,type="l",ylim=c(0,maximum))
par(new=T)
plot(out$NPP,type="l",ylim=c(0,maximum),col=2)
par(new=F)
legend("topleft",legend = c("hetero_resp","NPP"),col = c(1,2),lty = 1)
dev.off()

