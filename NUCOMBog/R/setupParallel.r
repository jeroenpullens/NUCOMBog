#' @title make setupParallel
#' @description Code to make setupParallel, this is needed to run the model in parallel.
#'
#' @author Jeroen Pullens
#' @param WD Working directory
#' @param climate climate input (monthly) format: year month temp prec pot evap (tab seperated)
#' @param environment environment input (yearly) format: year co2 nitrogen deposition
#' @param inival initial values of biomass
#' @param start year in which to start
#' @param end year in which to end
#' @param type which output do you want? "NEE" and/or "WTD"
#' @param parameters possibility to add own parameters, BUT is has to in a datafram format with colum names: "names" and "values", see example.
#'
#' @return a list with paths and filenames and parameter values which can be implemented in runnucomParallel
#'
#' @keywords NUCOMBog
#'
#' @examples
#' \dontrun{
#' names<-rep(c("CO2ref","gram_Beta"),each=50)
#' values<-c(seq(300,500,length.out = 50),seq(0.1,1,length.out = 50))
#' test_par<-data.frame(names,values)
#' test_setup<-setupParallel(WD="/home/jeroen/test_package/",climate="ClimateLVM.txt",environment="EnvironmentLVM.txt",inival="inivalLVM.txt",start=1800,end=1805,type=c("NEE","WTD"),parameters=test_par)
#' }
#'

setupParallel<-function(WD,climate,environment,inival,start,end,type,parameters){


  parameterList <-data.frame(matrix(nrow=nrow(parameters),ncol=ncol(parameters)))
  names(parameterList)<-c("names","values")
  for (i in 1:nrow(parameters)) {

    par <- parameters[i,]
    parameterList[i,1] <- as.character(par$names)
    parameterList[i,2] <- par$values
    SetupParameters<-replicate(nrow(parameterList), list())
  }

  for(j in 1:length(SetupParameters)){
    SetupParameters[[j]]<-list(WD=paste(WD,"folder",j,"/",sep=""),climate=climate,environment=environment,inival=inival,start=start,end=end,par=parameterList[j,],type=type)
  }
  return(list(runParameters=SetupParameters))
}
