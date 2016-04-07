outyr<-read.csv("output/outyr.txt",sep="",header=F,skip = 1)
outyr<-outyr[1:(nrow(outyr)-4),]
names(outyr)<-c("Year","LI_gram","LI_eric","LI_humm","LI_lawn","LI_holl","Cbiomass_gram","Cbiomass_eric","Cbiomass_humm","Cbiomass_lawn","Cbiomass_holl","Cbiomass_totalC","Nbiomass_totalN","SOC_lvms","SOC_acro","SOC_cato","SON_lvms","SON_acro","SON_cato","N_soil_moisture_acro","N_soil_moisture_cato","N_soil_moisture_NAccCato","NPP_gram","NPP_eric","NPP_humm","NPP_lawn","NPP_holl","Nitrogen_uptake_gram","Nitrogen_uptake_eric","Nitrogen_uptake_humm","Nitrogen_uptake_lawn","Nitrogen_uptake_holl","Decomposition_lvms","Decomposition_acro","Decomposition_cato","N_min_lvms","N_min_acro","N_min_cato","Ndep","Nleach","Thickness_lvms","Thickness_acro","Thickness_cato","Thickness_total","Water_level_mean","Water_level_max","Water_level_min","Temp","T*WGrF_gram","NLim_gram","T*WGrF_eric","NLim_eric","T*WGrF_humm","NLim_humm","T*WGrF_lawn","NLim_lawn","T*WGrF_holl","NLim_holl","Water_mm","ETref","Evapotranspiration_total","Evapotranspiration_moss","Evapotranspiration_vasc","Prec","Drain")

par(mfrow=c(4,1))
plot(outyr$Thickness_lvms,type="l")
plot(outyr$Thickness_acro,type="l")
plot(outyr$Thickness_cato,type="l")
plot(outyr$Thickness_total,type="l")
par(mfrow=c(1,1))

plot(outyr$SOC_lvms/outyr$SON_lvms,type="l")
plot(outyr$SOC_acro/outyr$SON_acro,type="l")
plot(outyr$SOC_cato/outyr$SON_cato,type="l")

height<-data.frame(rbind(outyr$Thickness_lvms,outyr$Thickness_acro,outyr$Thickness_cato))

barplot(as.matrix(height))
