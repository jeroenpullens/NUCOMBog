#' SMC sampler
#'
#' @param likelihood likelihood function (or posterior if the initial sample is not the posterior)
#' @param initialParticles initial particles
#' @param iterations number of iterations
#' @param resampling if new particles should be created at each iteration
#' @export
smc_sampler <- function(likelihood, initialParticles, iterations = 4, resampling = T, proposal = NULL, parallel=F,setup=NULL,clustertype="SOCK",numCores=1,parameters,scaled,originalvalues){

  # calculates the likelihood for a number of particles
  getLikelihood <- function(likelihood){
    if (parallel == "external") likelihoodParallel(setup,clustertype,numCores,parameters,scaled,originalvalues)
    else if (parallel == T) stop("not yet implemented") # TODO
    else apply(particles, 1, likelihood)
  }

  if (is.null(proposal)) proposal <- function(x) rnorm(length(x), mean = x, sd = 0.2)

  particles <- initialParticles

  numPar <- ncol(initialParticles)

  for (i in 1:iterations){

    likelihoodValues <- getLikelihood(likelihood)

    relativeL = exp((likelihoodValues/180))^(1/iterations)
    sel = sample.int(n=length(likelihoodValues), size = length(likelihoodValues), replace = T, prob = relativeL)
    particles = particles[,sel+1]


    if (resampling == T){

      particlesProposals<-matrix(ncol=ncol(particles),nrow=nrow(particles))
      for(i in 1:ncol(particles)){
        particlesProposals[,i] = proposal(particles[,i])
      }


      particlesProposals<-data.frame(parind$names,particlesProposals)
      names(particlesProposals)<-c("names",rep("values",ncol(particles)))

      particlesProposalsLikelihood <- getLikelihood(likelihood)

      jumpProb <- exp(particlesProposalsLikelihood - likelihoodValues[sel])

      accepted <- jumpProb > runif(length(particlesProposalsLikelihood), 0 ,1)


      particles[,accepted ] = particlesProposals[, accepted]

    }

  }
  return(particles )
}





