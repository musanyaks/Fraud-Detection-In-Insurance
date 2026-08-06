# plumber.R

#* @apiTitle Insurance Fraud Detection API
#* @apiDescription API for scoring insurance claims for potential fraud.

#* Get API health
#* @get /health
function() {
  handle_health()
}

#* Predict fraud for a claim
#* @post /predict
#* @param claim_data:object
function(req, res) {
  handle_predict(req, res, .globals$model_bundle)
}
