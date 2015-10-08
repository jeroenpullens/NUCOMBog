#' make function to run modelMEE ----
#'
#' @author jeroen pullens
#' @param WD
#'
#'
#'
#' run with complete parameter list
#' 198 parameters in total
#' addopted from Ramiro and Florian
# runnucom_parallel(WD="/home/jeroen/test_package/",climate="ClimateLVM.txt",environment="EnvironmentLVM.txt",inival="inivalLVM.txt",start=1800,end=1805,type=c("GPP","WTD"))
runnucom_parallel<-function(WD,climate,environment,inival,start,end,par=NULL,type=NULL,numCores=NULL,clustertype=NULL,numFolders=NULL){
  #we need to make the structure in all the folders (how many folders do we need?)
  
  # copy files and folders:
  clim<-readLines(con=paste("input/",climate,sep=""))
  env<-readLines(con=paste("input/",environment,sep=""))
  ini<-readLines(con=paste("input/",inival,sep=""))
  
  
  #make counter for folders
  for (i in 1:numFolders){
    # input folder with inival,clim,environm (these files do not change)
    filepath<-paste("folder",i,sep="")
    dir.create(filepath)
    dir.create(paste(filepath,"/input",sep=""))
    dir.create(paste(filepath,"/output",sep=""))
    writeLines(clim,paste(filepath,"/input/",climate,sep=""))
    writeLines(env,paste(filepath,"/input/",environment,sep=""))
    writeLines(ini,paste(filepath,"/input/",inival,sep=""))
    }
  
    # then run nucom which creates the "param.txt","Filenames"
  
  
  
  
  #runnucom(WD,climate,environment,inival,start,end,par=NULL,type=NULL)

#   # Initialisation of snowfall.
#   # Create cluster
#   print('Create cluster')
#   if (clusterType =="SOCK"){
#     snowfall::sfInit(parallel=TRUE, cpus=numCores, type="SOCK")
#   }else if (clusterType =="MPI"){
#     # Check if numCores is greater than
#     if (numCores > mpi.universe.size()){
#       cat ("Your requesting more cores than available. Please check your submission script.")
#       cat ( "Setting number of cores to the available cores")
#       numCores <- mpi.universe.size()
#     }
#     
#     snowfall::sfInit(parallel=TRUE, cpus=numCores) # Dont need to specify type
#   }
#   
#   # Exporting needed data and loading required
#   # packages on workers. --> If daa is loaded firs it can be exporte to all workers
#   snowfall::sfLibrary(Rconect)
#   snowfall::sfExport("runParameters")# it could be loaded data
#   
#   # Distribute calculation: will return values as a list object
#   cat ("Sending tasks to the cores\n")
#   result =  snowfall::sfSapply(runParameters, runLPJwrapper)
#   
#   # Stop snowfall
#   # Destroy cluster
#   snowfall::sfStop()
#   # deliver data to clusters
#   # Snow's close command, shuts down and quits from script
#   if (clusterType =="MPI"){
#     mpi.quit(save = "no") # Dont need to specify type
#   }
#   return(result)

}
