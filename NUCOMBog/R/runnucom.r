#' @title run NUCOMBog
#'
#' @description Code to run NUCOMBog.
#' @author Jeroen Pullens
#'
#' @param setup Add here all the essential information to run the model.
#' @param parameters The parameters which are used in the model. If no parameter values are given the default values will be used. The parameters have to have the format of a dataframe with colum names: "names" and "values", see example.
#'
#' @examples
#' \dontrun{
#' Single core:
#' test_setup_singlecore<-setup_NUCOM(mainDir="/home/jeroen/test_package/",climate="clim_1999-2013_measured.txt",environment="Env_Mer_Bleue_1999_2013.txt",inival="Inival_Mer_Bleue.txt",start=1999,end=2013,type=c("NEE","WTD"),parallel=F)
#' runnucom(setup = test_setup_singlecore,parameters=NULL)
#'}
#' @export

runnucom<-function(setup,parameters=NULL){

  startval=setup[[1]]$startval
   # print(parameters)
  if(!is.null(parameters)){
    setup<-combine_setup_parameters(runParameters = setup,parameters = parameters,parallel=F)
  }
  setup<-setup[[1]]

  # print(setup)
  setwd(setup$runDir)

  make_filenames(setup$runDir,setup$climate,setup$environment,setup$inival,setup$start,setup$end)

  make_param_file(setup$runDir,setup$parameters)

  system("./modelMEE")

  if(!is.null(setup$type)){
    out<-getData(setup,startval)
    return(out)
  }
}

