MPISapply <- function(numcores, runParameters) {
  rank <- Rmpi::mpi.comm.rank()
  # master doesnt work the data
  if (rank > 0){
    mywork <- runParameters[seq(rank, length(runParameters), numcores)]
    result <- sapply(mywork, runnucom_wrapper)
    return(result)
  }
}
