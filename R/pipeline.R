#' End-to-end Training Pipeline
#' @export
run_training_pipeline <- function(config_path = "config/config.yml") {
  cfg <- AppConfig$new(config_path)
  setup_logger()
  
  logger::log_info("Starting training pipeline")
  
  # 1. Generate Data
  data_raw <- generate_synthetic_claims(
    n = cfg$get("data", "n_claims"),
    fraud_rate = cfg$get("data", "fraud_rate"),
    seed = cfg$get("seed")
  )
  
  # 2. Preprocessing & Features
  data_feat <- create_features(data_raw)
  
  # 3. Train/Test Split
  set.seed(cfg$get("seed"))
  train_idx <- sample(seq_len(nrow(data_feat)), 0.8 * nrow(data_feat))
  train_df <- data_feat[train_idx, ]
  test_df <- data_feat[-train_idx, ]
  
  # 4. Train Model
  features <- cfg$get("model", "features")
  model <- train_model(
    train_df, 
    target = cfg$get("model", "target"),
    features = features,
    params = cfg$get("model", "params")
  )
  
  # 5. Evaluate
  metrics <- evaluate_model(model, test_df, target = cfg$get("model", "target"))
  logger::log_info("Model AUC: {metrics$auc}")
  
  # 6. Save Bundle
  registry <- ModelRegistry$new()
  registry$save_bundle(
    model = model,
    features = features,
    metrics = metrics,
    path = cfg$get("paths", "model_bundle")
  )
  
  logger::log_info("Pipeline completed successfully")
  return(metrics)
}
