#!/usr/bin/env Rscript
# scripts/01_generate_data.R
library(dplyr)
# Source all R files
r_files <- list.files("R", pattern = "\\.R$", full.names = TRUE)
invisible(lapply(r_files, source))

cfg <- AppConfig$new()
data <- generate_synthetic_claims(
  n = cfg$get("data", "n_claims"),
  fraud_rate = cfg$get("data", "fraud_rate")
)

write.csv(data, cfg$get("paths", "data_raw"), row.names = FALSE)
message("Data generated and saved to ", cfg$get("paths", "data_raw"))
