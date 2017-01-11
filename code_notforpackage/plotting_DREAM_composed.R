a<-out2

map<-MAP(a)
mapvalues<- map$parametersMAP

parameters<-data.frame(names,mapvalues)
names(parameters)<-c("names","values")

setup_SMC[[1]]$type <-c("NEE","WTD","hetero_resp","NPP")

out<-runNUCOM(setup = setup_SMC,parameters = parameters)

pdf("NEE.pdf")
plotTimeSeries(observed = data$NEE,predicted = out$NEE)
dev.off()

pdf("WTD.pdf")
plotTimeSeries(observed = data$WTD/100,predicted = out$WTD)
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

pdf("NEE_all.pdf")
for(i in 1:length(outcome)){
  plot(outcome[[i]]$NEE,ylim=c(-60,25),col="lightgray",type="l")
  par(new=T)
}
points(data$NEE,col=2,type="p")
par(new=T)
plot(out$NEE,ylim=c(-60,25),col="black",type="l",main=length(outcome))
par(new=F)
dev.off()

pdf("WTD_all.pdf")
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

pdf("hetero_NPP.pdf")
plot(out$hetero_resp,type="l",ylim=c(0,90))
par(new=T)
plot(out$NPP,type="l",ylim=c(0,90),col=2)
par(new=F)
dev.off()

