#' API Handlers
#' @export
handle_predict <- function(req, res, model_bundle) {
  claim_data <- tryCatch({
    jsonlite::fromJSON(req$postBody)
  }, error = function(e) {
    res$status <- 400
    return(list(error = "Invalid JSON"))
  })
  
  # Validate
  tryCatch({
    validate_claim(claim_data)
  }, error = function(e) {
    res$status <- 400
    return(list(error = e$message))
  })
  
  # Predict
  result <- predict_fraud(model_bundle, as.data.frame(claim_data))
  
  return(result)
}

#' Health check
#' @export
handle_health <- function() {
  list(status = "alive", timestamp = Sys.time())
}
