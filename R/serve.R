#' Predict Fraud
#' @export
predict_fraud <- function(model_bundle, new_data) {
  # 1. Feature Engineering
  features_df <- create_features(new_data)
  
  # 2. Rule Engine
  rule_flags <- compute_flags(new_data)
  
  # 3. Model Scoring
  # Ensure only model features are passed
  model_input <- features_df[, model_bundle$features, drop = FALSE]
  pred_prob <- predict(model_bundle$model, data = model_input)$predictions[, 2]
  
  # 4. Decision Logic
  decision <- if_else(pred_prob > 0.5 | rule_flags$any_rule_hit, "Review", "Approve")
  
  return(list(
    probability = pred_prob,
    rules = rule_flags,
    decision = decision
  ))
}
