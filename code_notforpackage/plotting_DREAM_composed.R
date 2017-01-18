date<-Sys.Date()
a<-out2

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

pdf(paste("WTD",date,".pdf",sep=""))
plotTimeSeries(observed = data$WTD/100,predicted = out$WTD)
abline(h=0,col="lightgray")
dev.off()


codaObject = getSample(out2, coda = F,thin=500)
outcome<-NULL
for(i in 1:nrow(codaObject)){
  print(i)
  newparameters<-data.frame(names,codaObject[i,])
  names(newparameters)<-c("names","values")
  newparameters$names<-as.character(newparameters$names)
  outcome[[i]]<-runNUCOM(setup = setup_SMC, parameters = newparameters)
}

pdf(paste("NEE",date,"_all.pdf",sep=""))
for(i in 1:length(outcome)){
  plot(outcome[[i]]$NEE,ylim=c(-60,25),col="lightgray",type="l")
  par(new=T)
}
points(data$NEE,col=2,type="p")
par(new=T)
plot(out$NEE,ylim=c(-60,25),col="black",type="l",main=length(outcome))
par(new=F)
dev.off()

pdf(paste("WTD",date,"_all.pdf",sep=""))
for(i in 1:length(outcome)){
  plot(outcome[[i]]$WTD,ylim=c(-0.8,0.1),col="lightgray",type="l")
  par(new=T)
}
points(data$WTD/100,col=2,type="p")
par(new=T)
plot(out$WTD,ylim=c(-0.8,0.1),col="black",type="l",main=length(outcome))
par(new=F)
dev.off()

plot(out$hetero_resp,type="l")
plot(out$NPP,type="l")

pdf(paste("hetero_NPP",date,".pdf",sep=""))
plot(out$hetero_resp,type="l",ylim=c(0,90))
par(new=T)
plot(out$NPP,type="l",ylim=c(0,90),col=2)
par(new=F)
legend("topleft",legend = c("hetero_resp","NPP"),col = c(1,2),lty = 1)
dev.off()

