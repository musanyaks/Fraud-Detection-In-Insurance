#' Helper: NULL-coalesce operator
#' @export
`%||%` <- function(a, b) if (!is.null(a)) a else b

#' Helper: Safe Division
#' @export
safe_divide <- function(n, d) {
  if (is.null(d) || d == 0) return(0)
  n / d
}

#' Helper: Top K elements
#' @export
topk <- function(x, k = 5) {
  head(sort(x, decreasing = TRUE), k)
}
