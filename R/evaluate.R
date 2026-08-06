#' Evaluate Model Performance
#' @import pROC
#' @export
evaluate_model <- function(model, test_data, target = "is_fraud") {
  preds <- predict(model, data = test_data)$predictions[, 2]
  actual <- test_data[[target]]
  
  roc_obj <- pROC::roc(actual, preds, quiet = TRUE)
  auc <- pROC::auc(roc_obj)
  
  return(list(
    auc = as.numeric(auc),
    thresholds = roc_obj$thresholds,
    sensitivities = roc_obj$sensitivities,
    specificities = roc_obj$specificities
  ))
}
