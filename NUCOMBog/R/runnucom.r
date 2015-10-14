#' @title run NUCOMBog
#'
#' @description Code to run NUCOMBog.
#' @author Jeroen Pullens
#' @param WD Working Directory
#' @param climate climate input (monthly) format: year month temp prec pot evap (tab seperated)
#' @param environment environment input (yearly) format: year co2 nitrogen deposition
#' @param inival initial values of biomass
#' @param start year in which to start
#' @param end year in which to end
#' @param type which output do you want? "NEE" and/or "WTD"
#'
#' @examples
#' \dontrun{
#' runnucom(WD="/home/jeroen/test_package/",climate="ClimateLVM.txt",environment="EnvironmentLVM.txt",inival="inivalLVM.txt",start=1800,end=1805,type=c("NEE","WTD"))
#' }

runnucom<-function(WD,climate,environment,inival,start,end,par=NULL,type=NULL){
  setwd(WD)

  make_filenames(WD,climate,environment,inival,start,end)

  make_param_file(WD,par)

  system("./modelMEE")

  if(!is.null(type)){
    out<-getData(WD,type)
    return(out)
  }
}
