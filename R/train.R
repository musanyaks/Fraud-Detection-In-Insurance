#' Train Fraud Model
#' @import ranger
#' @export
train_model <- function(data, target = "is_fraud", features = NULL, params = list()) {
  if (is.null(features)) {
    features <- setdiff(names(data), target)
  }
  
  formula_str <- paste(target, "~", paste(features, collapse = " + "))
  
  model <- ranger::ranger(
    formula = as.formula(formula_str),
    data = data,
    num.trees = params$num.trees %||% 500,
    mtry = params$mtry %||% floor(sqrt(length(features))),
    probability = TRUE,
    importance = "impurity"
  )
  
  return(model)
}
