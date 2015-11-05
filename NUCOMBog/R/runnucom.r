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
#' runnucom(setup = test_setup_singlecore,data=NULL)
#' runnucom(setup = test_setup_singlecore,likeli=T,data=data,parameters=list(initialParameters[[1]]))
#' runnucom(WD="/home/jeroen/test_package/",climate="ClimateLVM.txt",environment="EnvironmentLVM.txt",inival="inivalLVM.txt",start=1800,end=1805,type=c("NEE","WTD"),LL=F,data=NULL)
#'}

runnucom<-function(setup,likeli=NULL,data=NULL,parameters=NULL){

  # print(parameters)
  if(!is.null(parameters)){
    setup<-combine_setup_parameters(runParameters = setup,parameters = parameters)
  }

  setup<-setup[[1]]
  # print(setup)
  setwd(setup$runDir)

  make_filenames(setup$runDir,setup$climate,setup$environment,setup$inival,setup$start,setup$end)

  make_param_file(setup$runDir,setup$parameters)

  system("./modelMEE")

  if(!is.null(likeli)){
    out<-getData(setup)
    likelihood<-likelihood_nucom(observed=data,predicted = out,parameters = setup$parameters)
    return(likelihood)
    }
  if(!is.null(setup$type)){
    out<-getData(setup)
    return(out)
  }


}

