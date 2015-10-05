# make filenames -----------
make_filenames<-function(WD){
	filenames<-paste("Filenames",sep="")
	cat("[in]",file=filenames,sep="\n")
	cat(paste("directory=",WD,"input/",sep=""),file=filenames,append=TRUE,sep="\n")
	cat("climate=clim_1999-2013_measured.txt",file=filenames,append=TRUE,sep="\n")
	cat("environment=Env_Mer_Bleue_1999_2013.txt",file=filenames,append=TRUE,sep="\n")
	cat("parameters= param.txt",file=filenames,append=TRUE,sep="\n")
	cat("initval=Inival_Mer_Bleue.txt",file=filenames,append=TRUE,sep="\n")

	cat("[out]",file=filenames,append=TRUE,sep="\n") 
	cat(paste("directory=",WD,"output/",sep=""),file=filenames,append=TRUE,sep="\n") 
	cat("month=outmo.txt",file=filenames,append=TRUE,sep="\n") 
	cat("year=outyr.txt",file=filenames,append=TRUE,sep="\n") 
	cat("[year]",file=filenames,append=TRUE,sep="\n") 
	cat("start=1999",file=filenames,append=TRUE,sep="\n") 
	cat("end=2013",file=filenames,append=TRUE,sep="\n") 
}
