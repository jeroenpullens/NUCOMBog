a<-out2

map<-MAP(a)
mapvalues<- map$parametersMAP

parameters<-data.frame(names,mapvalues)
names(parameters)<-c("names","values")

out<-runNUCOM(setup = setup_SMC,parameters = parameters)

pdf("NEE.pdf")
plotTimeSeries(observed = data$NEE,predicted = out$NEE)
dev.off()

pdf("WTD.pdf")
plotTimeSeries(observed = data$WTD/100,predicted = out$WTD)
dev.off()