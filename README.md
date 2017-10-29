# NUCOMBog R package

A scientific paper about this package can be found here: http://www.sciencedirect.com/science/article/pii/S1574954116301091

Installation guide:

The R package is available on CRAN and can be installed by running:

```{r}
install.packages("NUCOMBog",dependencies=TRUE)
```

Once you have installed the package, you can access the package vignette that contains examples and brief instructions.

```{r}
library(NUCOMBog)
?NUCOMBog
vignette(package="NUCOMBog")
```

The executable is available in the folder "source_codes". In this folder there are precompiled executables for LINUX and Windows. The name of the executable has to remain "modelMEE".

# How to report errors

To report errors in the package, please use 

- the issue tracker in the github repository of NUCOMBog https://github.com/jeroenpullens/NUCOMBog/issues (prefered option)
- via email jeroenpullens[at]gmail.com


Below the status of the automatic Travis CI tests on the master branch (if this doesn load see [here](https://travis-ci.org/jeroenpullens/NUCOMBog))

[![Build Status](https://travis-ci.org/jeroenpullens/NUCOMBog.svg?branch=master)](https://travis-ci.org/jeroenpullens/NUCOMBog)
![Downloads](https://cranlogs.r-pkg.org/badges/NUCOMBog)






