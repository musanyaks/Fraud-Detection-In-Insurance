#' ClaimSchema R6 Class
#' @import R6
#' @import checkmate
#' @export
ClaimSchema <- R6::R6Class(
  "ClaimSchema",
  public = list(
    validate = function(data) {
      coll <- checkmate::makeAssertCollection()
      checkmate::assert_numeric(data$claim_amount, lower = 0, add = coll)
      checkmate::assert_integerish(data$policy_age_days, lower = 0, add = coll)
      checkmate::assert_integerish(data$claimant_age, lower = 18, add = coll)
      checkmate::reportAssertions(coll)
      return(TRUE)
    }
  )
)

#' Validate a claim record
#' @export
validate_claim <- function(claim_list) {
  schema <- ClaimSchema$new()
  schema$validate(claim_list)
}
