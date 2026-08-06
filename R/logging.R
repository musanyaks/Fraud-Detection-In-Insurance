#' Initialize Logger
#' @import logger
#' @export
setup_logger <- function(level = logger::INFO) {
  logger::log_threshold(level)
  logger::log_layout(logger::layout_glue_colors)
}
