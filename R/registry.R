#' ModelRegistry R6 Class
#' @import R6
#' @export
ModelRegistry <- R6::R6Class(
  "ModelRegistry",
  public = list(
    save_bundle = function(model, features, metrics, path) {
      bundle <- list(
        model = model,
        features = features,
        metrics = metrics,
        timestamp = Sys.time()
      )
      saveRDS(bundle, path)
    },
    
    load_bundle = function(path) {
      if (!file.exists(path)) stop("Model bundle not found.")
      readRDS(path)
    }
  )
)
