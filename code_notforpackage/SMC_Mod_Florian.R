#' SMC sampler
#'
#' @param likelihood likelihood function (or posterior if the initial sample is not the posterior)
#' @param initialParticles initial particles
#' @param iterations number of iterations
#' @param resampling if new particles should be created at each iteration
#' @export
smc_sampler <- function(likelihood,prior=NULL, initialParticles, iterations = 4, resampling = T, proposal = NULL, parallel=F,setup=NULL,clustertype="SOCK",numCores=1,parameters,scaled,originalvalues){
  if (is.null(prior)){
    prior <- function(x){
      return(0)
    }
  }

  if (parallel == T) {
    warning("cluster in parallel not implemented yet, no speedup from parallel option")
    parallelLikelihood <- generateParallelExecuter(likelihood)
  }

  # calculates the likelihood for a number of particles
  getLikelihood <- function(particles){
    if (parallel == "external") likelihoodParallel(setup,clustertype,numCores,parameters,scaled,originalvalues)
                                           else if (parallel == T) parallelLikelihood(particles)
                                           else apply(particles, 1, likelihood)
  }

  getPrior<- function(particles){
    apply(particles, 2, prior)
  }

  if (is.null(proposal)) proposal <- function(x) rnorm(length(x), mean = x, sd = 0.2)

  particles <- initialParticles

  numPar <- nrow(initialParticles)

  for (i in 1:iterations){

    likelihoodValues <- getLikelihood(particles)

    relativeL = exp(likelihoodValues -max(likelihoodValues)) ^(1/iterations)
    # relativeL[which(is.infinite(relativeL))]<-1
    sel = sample.int(n=length(likelihoodValues), size = length(likelihoodValues), replace = T, prob = relativeL)
    particles = particles[,sel]

    if (numPar == 1) particles = matrix(particles, ncol = 1)

    if (resampling == T){

      if (numPar == 1) particlesProposals = matrix(apply(particles, 1, proposal), ncol = 1)
      else particlesProposals = t(apply(particles, 1, proposal))

      jumpProb <- exp(getLikelihood(particlesProposals) - likelihoodValues[sel])^(i/iterations) * exp(getPrior(particlesProposals)   - getPrior(particles))

      accepted <- jumpProb > runif(length(jumpProb), 0 ,1)

      particles[,accepted ] = particlesProposals[,accepted ]
    }
  }
  return(particles )
}

