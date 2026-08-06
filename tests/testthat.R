# Source all R modules first
r_files <- list.files("R", pattern = "\\.R$", full.names = TRUE)
invisible(lapply(r_files, source))

# Run tests
library(testthat)
test_dir("tests/testthat")