#' @title Run NUCOMBog_parallel
#' @description Code to run NUCOMBog parallel, but first run setup_NUCOM
#'
#' @author JWM Pullens
#' @param setup The setup needs to be made before by running the setup_NUCOM function.
#' @param clustertype Clustertype: "MPI" is cluster and personal computer is "SOCK"
#' @param numCores Number of Cores on which are model needs to be run (NOTE: Non-parallel runs can only be run on 1 core)
#' @param parameters List of parameters
#' @keywords NUCOMBog
#'
#' @examples
#' \dontrun{
#' !!test_setup is from the function setup_NUCOM!!
#'
#' parallel<-runnucom_parallel(setup = test_setup,
#'                             clustertype = "SOCK",
#'                             numCores = 1,
#'                             parameters=initialParameters)
#' }
#' @export
#' @import snow
#' @import snowfall

runnucom_parallel<-function(setup,clustertype,numCores=1,parameters){
   setwd(setup$runParameters[[1]]$mainDir)
    #we need to make the structure in all the folders
  runParameters<-setup$runParameters


  runParameters<-combine_setup_parameters(runParameters = runParameters,parameters = parameters)
  pb <- txtProgressBar(min = 0, max = length(runParameters), style = 3)
  print("Making Folder Structure")
  for (i in 1:length(runParameters)){
    setTxtProgressBar(pb, i)
    # copy files and folders:
    clim<-readLines(con=paste("input/",runParameters[[i]]$climate,sep=""))
    env<-readLines(con=paste("input/",runParameters[[i]]$environment,sep=""))
    ini<-readLines(con=paste("input/",runParameters[[i]]$inival,sep=""))

    filepath<-paste("folder",i,sep="")
    dir.create(filepath,showWarnings = F)

    # input folder with inival,clim,environm (these files do not change)
    dir.create(paste(filepath,"/input",sep=""),showWarnings = F)
    dir.create(paste(filepath,"/output",sep=""),showWarnings = F)
    writeLines(clim,paste(filepath,"/input/",runParameters[[i]]$climate,sep=""))
    writeLines(env,paste(filepath,"/input/",runParameters[[i]]$environment,sep=""))
    writeLines(ini,paste(filepath,"/input/",runParameters[[i]]$inival,sep=""))
    file.copy(from = "modelMEE",to = paste(filepath,"/",sep="") )
  }
  close(pb)
  print("Folder Structure Made")
  # then run nucom which creates the "param.txt","Filenames"

  # Create cluster
  print('Create cluster')
  if (clustertype =="SOCK"){
    snowfall::sfInit(parallel=TRUE, cpus=numCores, type="SOCK")
  }else if (clustertype =="MPI"){
    snowfall::sfInit(parallel=TRUE, cpus=numCores, type="MPI") # Dont need to specify type
  }

  # Exporting needed data and loading required packages on workers
  snowfall::sfLibrary(NUCOMBog)
  snowfall::sfExport("setup","runParameters")

  # Distribute calculation: will return values as a list object
  cat ("Sending tasks to the cores\n")
  result =  snowfall::sfSapply(runParameters,runnucom_wrapper)

  # Destroy cluster
  snowfall::sfStop()
  return(result)
}

