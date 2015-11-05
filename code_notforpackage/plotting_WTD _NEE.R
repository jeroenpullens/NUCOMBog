graphics.off()
data<-read.csv("input/NEE_WTD_GPP_MERBLEUE_1999_2013.csv",sep="\t",as.is=T)
data<-data[2:nrow(data),]
data<-as.data.frame(lapply(data,as.numeric))
data[data==-9999]<-NA
# runnucom(outDEoptim$optim$bestmem)
# runnucom(norm)

output<-read.csv(paste(WD,"output/outmo.txt",sep=""),sep="",header=F,skip = 1)
output<-output[1:(nrow(output)-4),]
names(output)<-c("Year","Month","PotGr_gram","ActGr_gram","PotNUpt_gram","ActNUpt_gram","PotGr_eric","ActGr_eric","PotNUpt_eric","ActNUpt_eric","PotGr_humm","ActGr_humm","PotNUpt_humm","ActNUpt_humm","PotGr_lawn","ActGr_lawn","PotNUpt_lawn","ActNUpt_lawn","PotGr_holl","ActGr_holl","PotNUpt_holl","ActNUpt_holl","TotCDecLvms","TotCDecAcro","TotCDecCato","Water_level_mm_below_moss_surface","Evaporation_mm_mo-1","Transpiration_mm_mo-1","Drain_mm_mo-1")
out_NPP<-numeric()
out_DECOMP<-numeric()
out_NEE<-numeric()
wtd<-numeric()

for(i in 1:nrow(output)){ #first row of output is empty and last 4 are filenames
  out_NPP[i]<-(sum(output[i,4],output[i,8],output[i,12],output[i,16],output[i,20]))
  out_DECOMP[i]<-sum(output[i,23:25])
  out_NEE[i]<-out_NPP[i]-out_DECOMP[i]
  wtd[i]<-(-1*output[i,26]/1000)
}


miny=-1
maxy=0
plot((data$WTD/100),type="l",col=2,ylim=c(miny,maxy),xlab="",ylab="")
par(new=T)
plot(wtd,type="l",ylim=c(miny,maxy),xlab="months",ylab="meters")
par(new=F)

#residuals
res_wtd<-wtd-data$WTD/100
# plot(res_wtd~wtd)
# abline(0,1,col=2)

# start plotting
plot((data$WTD/100),wtd,ylim=c(miny,maxy),xlim=c(miny,maxy))
abline(0,1,col=2)
acf(wtd,lag.max = 180)
acf(na.omit(data$WTD/100),lag.max = 180)
acf(na.omit(res_wtd),lag.max = 180)

miny=-80
maxy=60
plot(data$NEE,type="l",col=2,ylim=c(miny,maxy),xlab="",ylab="")
par(new=T)
plot(-out_NEE,type="l",ylim=c(miny,maxy),xlab="time (months)",ylab="g C/ month",main = "Net Ecosystem Exchange")
par(new=T)
plot(out_DECOMP,type="l",ylim=c(miny,maxy),xlab="",ylab="",col=3)
# par(new=T)
# plot(out_NPP,type="l",ylim=c(miny,maxy),xlab="",ylab="",col=4)
# par(new=F)
abline(h=0,col="gray",lty=2)
legend("topright",legend=c("observed NEE","modeled NEE"),col = c(2,1),lty = 1)
legend("topright",legend=c("observed NEE","modeled NEE","modeled Decomposition"),col = c(2,1,3),lty = 1)
legend("bottomright",legend=c("observed NEE","modeled NEE","modeled Decomposition"),col = c(2,1,3,4),lty = 1)

plot(data$NEE,out_NEE,xlim=c(miny,maxy),ylim=c(miny,maxy))
abline(0,1,col=2)

acf(out_NEE,lag.max = 180)
acf(data$NEE,lag.max = 180)

#residuals
res_NEE<-(-out_NEE)-data$NEE
# plot(res_NEE~-out_NEE)
acf(res_NEE,lag.max = 180)


