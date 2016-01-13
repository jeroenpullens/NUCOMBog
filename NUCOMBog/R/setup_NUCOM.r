#' @title make setupParallel
#' @description Code to make setupParallel, this is needed to run the model in parallel.
#'
#'
#' @author Jeroen Pullens
#' @param WD Working directory
#' @param climate climate input (monthly) format: year month temp prec pot evap (tab seperated)
#' @param environment environment input (yearly) format: year co2 nitrogen deposition
#' @param inival initial values of biomass
#' @param start year in which to start
#' @param end year in which to end
#' @param type which output do you want? There is the possibility to output Net Primary Production (NPP), Net Ecosystem Exchange (NEE), autotrophic respiration (autotr_resp) and water table depth (WTD), for more information see the help of the getData function.
#' @param numFolders
#' @param parallel
#' @param startval
#'
#' @return a list with paths and filenames and parameter values which can be implemented in runnucomParallel or in runnucom it self which is a single core run.
#'
#' @keywords NUCOMBog
#'
#' @examples
#' \dontrun{
#' Single core setup:
#' test_setup_singlecore<-setup_NUCOM(mainDir="/home/jeroen/test_package/",climate="clim_1999-2013_measured.txt",environment="Env_Mer_Bleue_1999_2013.txt",inival="Inival_Mer_Bleue.txt",start=1999,end=2013,type=c("NEE","WTD"),parallel=F,separate=F)
#'
#' Multi core setup:
#' names<-c("CO2ref","gram_Beta","sd1","sd2")
#'
#' nparvector<-50
#' initialParameters<-matrix(runif(n=length(names)*nparvector,min=c(300,0.1,0.01,0.01),max=c(500,1,1,1)),nrow=length(names))
#' initialParameters<-data.frame(names,initialParameters)
#' names(initialParameters)<-c("names",rep("values",nparvector))
#' initialParameters$names<-as.character(initialParameters$names)
#'
#' test_setup<-setup_NUCOM(mainDir="/home/jeroen/test_package/",climate="clim_1999-2013_measured.txt",environment="Env_Mer_Bleue_1999_2013.txt",inival="Inival_Mer_Bleue.txt",start=1999,end=2013,type=c("NEE","WTD"),parallel=T,numFolders=nparvector,separate=F,startval=1)
#' }
#' @export

setup_NUCOM<-function(mainDir,climate,environment,inival,start,end,type,numFolders=1,parallel=T,separate=F,startval=1){
  if(parallel==T){
    setup_parameters<-list()
    for(j in 1:numFolders){
      setup_parameters[[j]]<-list(mainDir=mainDir,runDir=paste(mainDir,"folder",j,"/",sep=""),climate=climate,environment=environment,inival=inival,start=start,end=end,type=type,parameters=NULL,separate=separate,startval=startval)
    }
    return(list(runParameters=setup_parameters))
  }
  if(parallel==F){
    setup_parameters<-list(list(mainDir=mainDir,runDir=mainDir,climate=climate,environment=environment,inival=inival,start=start,end=end,type=type,parameters=NULL,separate=separate,startval=startval))
  }
 }
