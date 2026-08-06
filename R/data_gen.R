#' Generate Synthetic Claims Data
#' @import dplyr
#' @export
generate_synthetic_claims <- function(n = 1000, fraud_rate = 0.05, seed = 42) {
  set.seed(seed)
  
  claims <- tibble::tibble(
    claim_id = seq_len(n),
    claim_amount = rlnorm(n, meanlog = 8, sdlog = 1),
    policy_age_days = sample(30:3650, n, replace = TRUE),
    claimant_age = sample(18:85, n, replace = TRUE),
    history_claims_count = rpois(n, lambda = 0.5),
    provider_risk_score = runif(n, 0, 100),
    is_fraud = sample(c(0, 1), n, replace = TRUE, prob = c(1 - fraud_rate, fraud_rate))
  )
  
  # Inject some fraud patterns
  claims <- claims %>%
    mutate(
      # High amount and low policy age increases fraud probability
      is_fraud = if_else(claim_amount > 20000 & policy_age_days < 90, 
                         sample(c(0, 1), n(), replace = TRUE, prob = c(0.2, 0.8)), 
                         is_fraud),
      # Provider risk score connection
      is_fraud = if_else(provider_risk_score > 90,
                         sample(c(0, 1), n(), replace = TRUE, prob = c(0.4, 0.6)),
                         is_fraud)
    )
    
  return(claims)
}
