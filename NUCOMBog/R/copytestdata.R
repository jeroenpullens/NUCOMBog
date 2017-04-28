#' @title Function to copy test data to user specified folder
#' @description
#' This function copies the test data from the R package to a user-defined folder. This is necesarry since the model does not read the data from R.
#'
#' The model needs to be run in a seperate folder and the executable can be downloaded from the provided URL. The executable needs to be copied to the folder where the data is located. The folder structure should be maintained.
#'
#' If the specified folder does not exist, the function will create it at the user defined loaction. If the packages are installed on default path, then the package_folder argument can be kept empty. If not, the user has to provide the path where the R package is installed.
#'
#' @author JWM Pullens
#' @source The executable and the source code of the model can downloaded from \url{https://github.com/jeroenpullens/source_modelMEE}.
#'
#' @usage copytestdata(new_folder,package_folder=NULL)
#' @param new_folder Folder to where the data needs to be copied
#' @param package_folder Folder where the R package is installed, if this is not specified during installation leave this empty.
#'
#' @examples
#' \dontrun{
#'  for Windows:
#'    copytestdata(new_folder="C:/testdata/",package_folder=NULL)
#'
#'  for Linux:
#'    copytestdata(new_folder="~/testdata/",package_folder=NULL)
#' }
#'@export
#'
#'

copytestdata<-function(new_folder,package_folder=NULL){
  #define path where the files/folders should be copied to
  if(dir.exists(new_folder)==FALSE){dir.create(new_folder)}
  if(is.null(package_folder)){
    file.copy(from = paste(.libPaths()[1],"/NUCOMBog/extdata/input/",sep=""),to = new_folder,recursive = T)
    file.copy(from = paste(.libPaths()[1],"/NUCOMBog/extdata/output/",sep=""),to = new_folder,recursive = T)
  }else{
    file.copy(from = paste(package_folder,"/NUCOMBog/extdata/input/",sep=""),to = new_folder,recursive = T)
    file.copy(from = paste(package_folder,"/NUCOMBog/extdata/output/",sep=""),to = new_folder,recursive = T)
  }
  print(paste("Folder structure succefully copied to ",new_folder))
  print("To run the model, the executable needs to be downloaded from the link provided in the documentation and copied into the folder where the data was just copied to")
}
