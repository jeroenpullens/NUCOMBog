#' runnucom
#' make function to run modelMEE
#'
#' @author jeroen pullens
#' @param WD Working Directory
#' @param par parameter list
#' @param subset Is there a subset of the parameters used?
#' @param Type to data to be retrieved, see getData()
#'
#' @examples
#' \dontrun{
#' runnucom(WD,par, subset = F, type=NULL)
#' }
#'
# 'run with complete parameter list
# '198 parameters in total

runnucom<-function(WD,climate,environment,inival,start,end,par, subset = F, type=NULL){
  make_filenames(WD,climate,environment,inival,start,end)

  if (subset == T)  make_param_file_subset(par)
  else make_param_file(par)

  system("./modelMEE")

  if(!is.null(type)){
    out<-getData(type)
    return(out)
  }
}
