# source code and files of ModelMEE, used in the NUCOMBog R package

In this github repository the executable of the NUCOMBog model can be found. The model is available for LINUX (UNIX) and Windows. In the folders a precompiled executable can be found. These executables have been tested and work without installation.

In case the user wants to compile the software, the necessary files are in the folder as well (such as makefiles and the source code).

The executable has to be copied into the folder where the input and output folder are (see http://jeroenpullens.github.io/NUCOMBog_data/). The data is also integrated in the NUCOMBog R package and can be copied to a user specified folder by using the "copytestdata" function.

Questions or comments can be sent to jeroenpullens[at]gmail[dot]com

# Case study: Walton Moss, England
As indicated before, in the R package there are test data files integrated. This data needs to be copied to a user-defined folder, where also the executable needs to be copied to. Here we present how a model run of NUCOMBog can be initialized, in this case historic data from the Walton Moss site in England will be used (Heijmans et al. 2008). First the package should be installed before the data can be copied from the R package to a user defined folder

```{r}
install.packages("NUCOMBog")
copytestdata(new_folder = "/home/jeroen/test_data/")
```

After this step the executable of the model is copied into the folder. The folder structure has to be kept intact. When the executable is copied, the model can be ran by using the following commands.

```{r}
test_setup_singlecore<-setupNUCOM(mainDir="/home/jeroen/test_data/",climate="ClimWLMhis.txt",environment="EnvWLMhis.txt",inival="inivalWLMhis.txt",start=1766,end=1999,type=c("NEE","WTD","NPP","hetero_resp"),parallel=F)
output<-runNUCOM(setup = test_setup_singlecore,parameters=NULL)
```
The model has been run from 1766 to 1999 and the requested output is: NEE, WTD, NPP and heterotrophic respiration, which is stored in the variable “output”. This output is integrated in the R environment and can be used for further analysis, like plotting.

![plot_WaltonMoss](jeroenpullens.github.com/source_modelMEE/images/WaltonMoss.pdf)
 
Simulated monthly NPP, NEE, heterotrophic respiration and WTD from 1980 till 1999 for Walton Moss, England.



