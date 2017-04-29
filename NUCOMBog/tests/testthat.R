Sys.setenv("R_TESTS" = "")

library(NUCOMBog)
library(testthat)

test_check("NUCOMBog")
