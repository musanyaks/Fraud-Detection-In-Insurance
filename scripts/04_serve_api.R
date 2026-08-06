#!/usr/bin/env Rscript
# scripts/04_serve_api.R

library(plumber)

# Source all R files
r_files <- list.files("R", pattern = "\\.R$", full.names = TRUE)
invisible(lapply(r_files, source))

# Source API handlers and startup
source("api/request_handlers.R")
source("api/startup.R")

pr <- plumber::plumb("api/plumber.R")
pr$run(host = "0.0.0.0", port = 8000)
