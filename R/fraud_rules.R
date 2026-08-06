#' Hybrid Rule Engine
#' @export
compute_flags <- function(data) {
  # returns a list of logical flags for each observation
  flags <- list(
    high_amount_new_policy = data$claim_amount > 15000 & data$policy_age_days < 60,
    very_high_provider_risk = data$provider_risk_score > 95,
    multiple_recent_claims = data$history_claims_count > 3
  )
  
  # Combine into a summary flag
  flags$any_rule_hit <- Reduce(`|`, flags)
  return(as.data.frame(flags))
}
