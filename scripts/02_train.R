#!/usr/bin/env Rscript
# scripts/02_train.R

# Source all R files since we haven't built the package
library(dplyr)
r_files <- list.files("R", pattern = "\\.R$", full.names = TRUE)
invisible(lapply(r_files, source))

metrics <- run_training_pipeline()
message("Training completed.")
