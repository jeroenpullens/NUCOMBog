#' @title run NUCOMBog
#'
#' @description Code to run NUCOMBog.
#' @author Jeroen Pullens
#'
#' @param setup Add here all the essential information to run the model.
#' @param likeli Possibility to add a likelihood function to be able to cailbrate the model.
#' @param data Here the data is inserted
#' @param parameters The parameters which are used in the model. If no parameter values are given the default values will be used. The parameters have to have the format of a dataframe with colum names: "names" and "values", see example.
#'
#' @examples
#' \dontrun{
#' The initialParameters in this function are created in the setup() function
#'
#' runnucom(setup = test_setup_singlecore,data=data,parameters=list(initialParameters[[1]]))
#'
#'}
#' @export

runnucom<-function(setup,likeli=NULL,data=NULL,parameters=NULL){


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

