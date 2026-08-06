#' Feature Engineering
#' @import dplyr
#' @export
create_features <- function(data) {
  data %>%
    mutate(
      amount_per_day = claim_amount / (policy_age_days + 1),
      is_senior = if_else(claimant_age > 65, 1, 0),
      high_provider_risk = if_else(provider_risk_score > 80, 1, 0)
    )
}
