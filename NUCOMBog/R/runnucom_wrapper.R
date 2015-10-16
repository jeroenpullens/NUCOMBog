#' @title Run NUCOMBog wrapper
#' @description Code to run NUCOMBog wrapper, escpecially made for the parallel computing
#'
#' @author Jeroen Pullens
#' @param runParameters list of:
#'        $WD = Working directory
#'        $climate = name of climate file
#'        $environment = name of environment file
#'        $inival = name of initial values file
#'        $start  = start year
#'        $end = end year
#'        $par = data.frame(names,values)
#'
#' @keywords NUCOMBog

runnucom_wrapper<-function(runParameters){

  setwd(dir = runParameters$mainDir)

  make_filenames(WD = runParameters$mainDir,climate = runParameters$climate,environment = runParameters$environment,inival = runParameters$inival,start = runParameters$start,end = runParameters$end)

  allpar<-make_param_file(WD = runParameters$mainDir,par = runParameters$par)

  system("./modelMEE")

  if(!is.null(runParameters$type)){
    out<-getData(runParameters$mainDir,runParameters$type)
    return(out)
  }

}
