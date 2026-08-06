#' API Startup script

# Source all R files
r_files <- list.files("R", pattern = "\\.R$", full.names = TRUE)
invisible(lapply(r_files, source))

# Load configuration
cfg <- AppConfig$new("config/config.yml")

# Load model bundle
registry <- ModelRegistry$new()
model_bundle <- registry$load_bundle(cfg$get("paths", "model_bundle"))

# Global model bundle for the API
.globals <- new.env()
.globals$model_bundle <- model_bundle
