#DEoptim<-runnucom_DEoptim(WD="/home/jeroen/test_package/",climate="ClimateLVM.txt",environment="EnvironmentLVM.txt",inival="inivalLVM.txt",start=1800,end=1805,name.data = "NEE_WTD_GPP_MERBLEUE_1999_2013.csv",sd_GPP = 1,sd_WTD = 1,iter = 1,min=0.5,max=1.5)

runnucom_DEoptim<-function(WD,climate,environment,inival,start,end,name.data,sd_GPP,sd_WTD,par=NULL,iter=1,min,max){
  setwd(WD)
  make_filenames(WD,climate,environment,inival,start,end)
  out<-numeric()
  normvalues<-numeric()
  minvalues<-numeric()
  maxvalues<-numeric()
  allparnew<-NULL
  likelihood_GPP<-numeric()
  likelihood_WT<-numeric()
  
  data<-read.csv(paste("data/",name.data,sep=""),sep="\t",as.is=T)
  data<-data[2:nrow(data),]
  data<-as.data.frame(lapply(data,as.numeric))
  data[data==-9999]<-NA
  
  allpar<-make_param_file(WD,par=NULL)
  values<-c(allpar$values,sd_GPP,sd_WTD)
  names<-c(allpar$names,"sd_GPP","sd_WTD")
  allpar<-data.frame(names,values)
  allpar$names<-as.character(allpar$names)
  
  
  for(i in 1:nrow(allpar)){
    if(allpar$value[i]!=0){
      normvalues[i]<-allpar$values[i]/allpar$values[i]
      if(allpar$value[i]<0){
        minvalues[i]<-max*allpar$values[i]
        maxvalues[i]<-min*allpar$values[i]
      }
      else{
        minvalues[i]<-min*allpar$values[i]
        maxvalues[i]<-max*allpar$values[i]
      }
    }
    else{
      normvalues[i]<-0
      minvalues[i]<-0
      maxvalues[i]<-0.0001
    }
  }
  
  run_Deoptim<-function(x,par=allpar){
    x<-x*par$values
    x<-data.frame(par$names,x)
    make_param_file(WD,x)
    system("./modelMEE")
    output<-read.csv(paste(WD,"output/outmo.txt",sep=""),sep="",header=F,skip = 1)
    output<-output[1:(nrow(output)-4),]
    for(i in 1:nrow(output)){ #first row of output is empty and last 4 are filenames
      out[i]<-sum(output[i,4],output[i,8],output[i,12],output[i,16],output[i,20])
      likelihood_GPP[i]=dnorm(data$GPP[i],mean=out[i],sd=x[which(x$par.names=="sd_GPP"),2],log=T)
      likelihood_WT[i]=dnorm((data$WaterTableDepth_NotFill[i]/100),mean=-1*(output[i,23]/1000),sd=x[which(x$par.names=="sd_WTD"),2],log=T)
    }
    sumll=sum(likelihood_GPP,likelihood_WT,na.rm=TRUE)*-1
    #sumll=sum(likelihood_GPP)*-1
    return(sumll)
  }
  
  
  #standardize the min/max and values. In the model function the 'x' is again multiplied with 'values'
  
  
  set.seed(1234)
  outDEoptim<-DEoptim(fn=run_Deoptim,lower=minvalues,upper=maxvalues,control = list(itermax=iter))
  # from Vignette DEoptim: The algorithm stops after some set number of generations, or after the objective function
  # value associated with the best member has been reduced below some set threshold, or if it is
  # unable to reduce the best member by a certain value over over set number of iterations.
  
  #default: itermax: 200
  #NP: 50 Number of parents
  #CR: 0.5 Crossover probability
  #F: 0.8  Stepsize
  
  return(outDEoptim)
}