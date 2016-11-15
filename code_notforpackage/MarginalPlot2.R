marginalPlot2<-
  function(mat, thin = "auto", bounds = NULL, true = NULL, ...){
    
    library(vioplot) # this fixes dirty import in vioplot, to avoid error Error in do.call("sm.density", c(list(data, xlim = est.xlim), args)) : could not find function "sm.density"
    
    if(inherits(mat,"bayesianOutput")) mat = getSample(mat, thin = thin, ...)
    
    numPars = ncol(mat)
    names = colnames(mat)
    
    
    if(!is.null(bounds)) {
      min = bounds[,1]
      max = bounds[,2]
      mat = BayesianTools:::scaleMatrix(mat, min, max)
      # true = BayesianTools:::scaleMatrix(true, min, max)
    }
    
    
    # TODO ... add names
    
    if(is.null(bounds)){
      main = "Marginal parameter uncertainty, unscaled"
    }else main = "Marginal parameter uncertainty\n scaled to min/max values provided"
    
    if(is.null(bounds)) xlim = range(mat)
    else xlim = c(0,1)
    
    plot(NULL, ylim = c(0,numPars +1), type="n", yaxt="n", xlab="", ylab="", xlim = xlim, main = main)
    for (i in 1:numPars){
      vioplot::vioplot(mat[,i], at = i, add = T, col = "orangered", horizontal = T)
      axis(side = 2,at=i,labels = names[i],las=1)
    }
    if(!is.null(true)) points(true,1:length(true), cex = 3, pch = 4, lwd = 2)
    
    
  }