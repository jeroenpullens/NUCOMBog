#' @title make a Filenames file
#'
#' @description Code to make a Filenames file. It is incorporated in runnucom(). In the filenames file there is all the information for NUCOMBog to run.
#' @author Jeroen Pullens
#' @param WD Working Directory
#' @param climate climate input (monthly) format: year month temp prec pot evap (tab seperated)
#' @param environment environment input (yearly) format: year co2 nitrogen deposition
#' @param inival initial values of biomass
#' @param start year in which to start
#' @param end year in which to end
#'
#' @examples
#' \dontrun{
#' make_filenames(WD="~/nucom/",climate = "climate.txt",environment = "environment.txt",inival = "inival.txt" ,start = 1995,end = 2000)
#' }
#'
#'
make_filenames<-function(WD,climate,environment,inival,start,end){
	filenames<-paste(WD,"Filenames",sep="")
	cat("[in]",file=filenames,sep="\n")
	cat(paste("directory=",WD,"input/",sep=""),file=filenames,append=TRUE,sep="\n")
	cat(paste("climate=",climate,sep=""),file=filenames,append=TRUE,sep="\n")
	cat(paste("environment=",environment,sep=""),file=filenames,append=TRUE,sep="\n")
	cat("parameters= param.txt",file=filenames,append=TRUE,sep="\n")
	cat(paste("initval=",inival,sep=""),file=filenames,append=TRUE,sep="\n")
  cat(file=filenames,append=TRUE,sep="\n")
	cat("[out]",file=filenames,append=TRUE,sep="\n")
	cat(paste("directory=",WD,"output/",sep=""),file=filenames,append=TRUE,sep="\n")
	cat("month=outmo.txt",file=filenames,append=TRUE,sep="\n")
	cat("year=outyr.txt",file=filenames,append=TRUE,sep="\n")
	cat(file=filenames,append=TRUE,sep="\n")
	cat("[year]",file=filenames,append=TRUE,sep="\n")
	cat(paste("start=",start,sep=""),file=filenames,append=TRUE,sep="\n")
	cat(paste("end=",end,sep=""),file=filenames,append=TRUE,sep="\n")
}
