# 🧪 tests/ — Test Suite

This directory contains unit tests for the fraud detection system using the **`testthat`** framework.

---

## Structure

```
tests/
├── testthat.R              # Test runner entry point
└── testthat/
    └── test-data_gen.R     # Data generation tests
```

---

## Files

### `testthat.R` — Test Runner

Entry point that runs all tests in the `testthat/` directory.

```r
library(testthat)
test_dir("tests/testthat")
```

---

### `test-data_gen.R` — Data Generation Tests

Tests for the synthetic data generator.

**Example tests:**
- Verify correct number of rows generated
- Verify fraud rate is approximately correct
- Verify all required columns exist
- Verify data types are correct

---

## Running Tests

### Run all tests
```bash
Rscript -e "testthat::test_dir('tests/testthat')"
```

### Run from R console
```r
testthat::test_dir("tests/testthat")
```

### Run with devtools
```r
devtools::test()
```

### Run via Makefile
```bash
make test
```

---

## Writing New Tests

Create a new file in `tests/testthat/` named `test-<module>.R`:

```r
test_that("feature engineering creates expected columns", {
  data_raw <- generate_synthetic_claims(100)
  data_feat <- create_features(data_raw)

  expect_true("amount_per_day" %in% names(data_feat))
  expect_true("is_senior" %in% names(data_feat))
  expect_true("high_provider_risk" %in% names(data_feat))
})

test_that("model training returns ranger object", {
  data <- generate_synthetic_claims(100)
  data_feat <- create_features(data)
  model <- train_model(data_feat, "is_fraud", names(data_feat)[-1])

  expect_s3_class(model, "ranger")
})

test_that("prediction returns probability between 0 and 1", {
  # ... setup model bundle ...
  result <- predict_fraud(model_bundle, new_data)

  expect_true(result$probability >= 0 && result$probability <= 1)
})

test_that("schema validation catches invalid data", {
  invalid_claim <- list(claim_amount = -100, policy_age_days = -5, claimant_age = 10)
  expect_error(validate_claim(invalid_claim))
})
```

---

## Test Coverage Areas

| Module | Tests Needed |
|--------|-------------|
| `data_gen.R` | ✅ Row count, fraud rate, column names, data types |
| `features.R` | ⬜ Feature columns created, no NA values |
| `train.R` | ⬜ Model is ranger object, predictions are probabilities |
| `evaluate.R` | ⬜ AUC is between 0 and 1 |
| `fraud_rules.R` | ⬜ Rules trigger correctly for known patterns |
| `schema.R` | ⬜ Validation catches invalid inputs |
| `serve.R` | ⬜ Prediction returns expected structure |
| `config.R` | ⬜ Missing config file throws error |
| `registry.R` | ⬜ Save/load roundtrip preserves model |

---

## CI/CD

Tests run automatically on every push via GitHub Actions (`.github/workflows/ci.yml`).
