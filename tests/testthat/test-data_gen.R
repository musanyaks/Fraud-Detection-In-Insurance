test_that("generate_synthetic_claims returns correct dimensions", {
  n <- 100
  df <- generate_synthetic_claims(n = n)
  expect_equal(nrow(df), n)
  expect_true("is_fraud" %in% names(df))
})
