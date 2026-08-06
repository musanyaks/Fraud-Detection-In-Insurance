#' AppConfig R6 Class
#' @import R6
#' @import yaml
#' @export
AppConfig <- R6::R6Class(
  "AppConfig",
  public = list(
    settings = NULL,
    
    initialize = function(path = "config/config.yml", config_name = "default") {
      if (!file.exists(path)) {
        stop("Config file not found: ", path)
      }
      full_cfg <- yaml::read_yaml(path)
      self$settings <- full_cfg[[config_name]]
    },
    
    get = function(...) {
      keys <- list(...)
      val <- self$settings
      for (key in keys) {
        val <- val[[key]]
        if (is.null(val)) break
      }
      return(val)
    }
  )
)
