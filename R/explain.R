#' Explain Model
#' @import vip
#' @export
get_importance <- function(model) {
  vip::vi(model)
}
