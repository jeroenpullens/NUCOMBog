#' @title Run NUCOMBog parallel
#' @description Code to run NUCOMBog parallel, but first run setupParallel
#'
#' @author Jeroen Pullens
#' @author adopted from Rconect package
#' @param setup list of:
#'        $WD = Working directory
#'        $climate = name of climate file
#'        $environment = name of environment file
#'        $inival = name of initial values file
#'        $start  = start year
#'        $end = end year
#'        $par = data.frame(names,values)
#'        $type = output
#'
#' @param mainDir main directory where the files are stored
#' @param clustertype Clustertype: "MPI" is cluster and personal computer is "SOCK"
#' @param numCores Number of Cores
#'
#' @keywords NUCOMBog
#'
#' @examples
#' \dontrun{
#' !!test_setup is from the function setup!!
#'
#' parallel<-runnucom_parallel(setup = test_setup,clustertype = "SOCK",numCores = 1,parameters=initialParameters)
#' }
#' @export
#' @import snow
#' @import snowfall

runnucom_parallel<-function(setup,clustertype,numCores,parameters){
   setwd(setup$runParameters[[1]]$mainDir)
    #we need to make the structure in all the folders (how many folders do we need?)
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

  # Initialisation of snowfall.
  # Create cluster
  print('Create cluster')
  if (clustertype =="SOCK"){
    snowfall::sfInit(parallel=TRUE, cpus=numCores, type="SOCK")
  }else if (clusterType =="MPI"){
    # Check if numCores is greater than
    if (numCores > mpi.universe.size()){
      cat ("You requesting more cores than available. Please check your submission script.")
      cat ( "Setting number of cores to the available cores")
      numCores <- mpi.universe.size()
    }

    snowfall::sfInit(parallel=TRUE, cpus=numCores) # Dont need to specify type
  }

  # Exporting needed data and loading required
  # packages on workers. --> If data is loaded first it can be export to all workers
  snowfall::sfLibrary(NUCOMBog)
  snowfall::sfExport("setup","runParameters")# it could be loaded data

  # Distribute calculation: will return values as a list object
  cat ("Sending tasks to the cores\n")
  result =  snowfall::sfSapply(runParameters,runnucom_wrapper)

  # Stop snowfall
  # Destroy cluster
  snowfall::sfStop()
  # deliver data to clusters
  # Snow's close command, shuts down and quits from script
  if (clustertype =="MPI"){
    mpi.quit(save = "no") # Dont need to specify type
  }
  return(result)
}

