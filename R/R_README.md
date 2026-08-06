# 📦 R/ — Core Package Modules

This directory contains the heart of the fraud detection system. Each file is a self-contained R module with a specific responsibility.

---

## Files

### `config.R` — Configuration Management

**Class:** `AppConfig` (R6)

Loads and serves application settings from `config/config.yml`.

```r
cfg <- AppConfig$new("config/config.yml")
cfg$get("data", "n_claims")        # 10000
cfg$get("model", "features")       # c("claim_amount", ...)
cfg$get("paths", "model_bundle")   # "artifacts/model_bundle.rds"
```

**Why R6?** Encapsulated state with clean `get()` interface. Supports nested key access.

---

### `data_gen.R` — Synthetic Data Generation

**Function:** `generate_synthetic_claims(n, fraud_rate, seed)`

Generates realistic insurance claims data with **embedded fraud patterns**:

- **Pattern 1:** High claim amount (> $20,000) + new policy (< 90 days) → 80% fraud
- **Pattern 2:** Provider risk score > 90 → 60% fraud
- **Base rate:** 5% fraud for all other claims

**Output columns:**
| Column | Type | Range |
|--------|------|-------|
| `claim_id` | integer | 1:n |
| `claim_amount` | numeric | Lognormal(μ=8, σ=1) |
| `policy_age_days` | integer | 30–3650 |
| `claimant_age` | integer | 18–85 |
| `history_claims_count` | integer | Poisson(λ=0.5) |
| `provider_risk_score` | numeric | Uniform(0, 100) |
| `is_fraud` | integer | 0 or 1 |

---

### `features.R` — Feature Engineering

**Function:** `create_features(data)`

Transforms raw claims into model-ready features:

| Feature | Formula | Purpose |
|---------|---------|---------|
| `amount_per_day` | `claim_amount / (policy_age_days + 1)` | Spending intensity |
| `is_senior` | `claimant_age > 65` | Age risk flag |
| `high_provider_risk` | `provider_risk_score > 80` | Provider risk flag |

**Usage:**
```r
data_raw <- generate_synthetic_claims(1000)
data_feat <- create_features(data_raw)
```

---

### `train.R` — Model Training

**Function:** `train_model(data, target, features, params)`

Trains a **Random Forest** using the `ranger` package.

**Default hyperparameters:**
| Parameter | Default | Description |
|-----------|---------|-------------|
| `num.trees` | 500 | Number of trees |
| `mtry` | √p | Features sampled per split |
| `probability` | TRUE | Return class probabilities |
| `importance` | "impurity" | Variable importance measure |

**Usage:**
```r
model <- train_model(
  data = train_df,
  target = "is_fraud",
  features = c("claim_amount", "policy_age_days", "claimant_age", "history_claims_count", "provider_risk_score"),
  params = list(num.trees = 500)
)
```

---

### `evaluate.R` — Model Evaluation

**Function:** `evaluate_model(model, test_data, target)`

Computes performance metrics:

| Metric | Description |
|--------|-------------|
| `auc` | Area Under ROC Curve |
| `thresholds` | Classification thresholds |
| `sensitivities` | True Positive Rate |
| `specificities` | True Negative Rate |

**Usage:**
```r
metrics <- evaluate_model(model, test_df, "is_fraud")
cat("AUC:", metrics$auc)  # ~0.87
```

---

### `fraud_rules.R` — Rule Engine

**Function:** `compute_flags(data)`

Deterministic rule-based system for **explainable fraud detection**:

| Rule | Condition | Severity |
|------|-----------|----------|
| `high_amount_new_policy` | `claim_amount > 15000` AND `policy_age_days < 60` | High |
| `very_high_provider_risk` | `provider_risk_score > 95` | Critical |
| `multiple_recent_claims` | `history_claims_count > 3` | Medium |
| `any_rule_hit` | ANY rule above is TRUE | — |

**Why rules?** ML models are black boxes. Rules provide **transparent, auditable** fraud indicators that regulators and auditors can understand.

---

### `serve.R` — Prediction & Decision Logic

**Function:** `predict_fraud(model_bundle, new_data)`

The inference pipeline that powers the API:

1. **Feature Engineering** — `create_features(new_data)`
2. **Rule Scoring** — `compute_flags(new_data)`
3. **ML Prediction** — `predict(model_bundle$model, ...)`
4. **Decision Logic** —
   - If `probability > 0.5` OR `any_rule_hit` → `"Review"`
   - Otherwise → `"Approve"`

**Returns:**
```r
list(
  probability = c(0.4364),
  rules = data.frame(...),
  decision = c("Review")
)
```

---

### `schema.R` — Input Validation

**Class:** `ClaimSchema` (R6)

Validates incoming claim data before scoring:

| Field | Validation |
|-------|-----------|
| `claim_amount` | Numeric, >= 0 |
| `policy_age_days` | Integer, >= 0 |
| `claimant_age` | Integer, >= 18 |

**Usage:**
```r
validate_claim(list(claim_amount = 50000, policy_age_days = 5, claimant_age = 45))
# Returns TRUE or throws error
```

**Why validate?** Prevents garbage-in-garbage-out. Catches malformed API requests early.

---

### `registry.R` — Model Registry

**Class:** `ModelRegistry` (R6)

Manages model artifacts (versioning, bundling, persistence):

```r
registry <- ModelRegistry$new()

# Save
registry$save_bundle(
  model = trained_model,
  features = feature_names,
  metrics = list(auc = 0.87),
  path = "artifacts/model_bundle.rds"
)

# Load
bundle <- registry$load_bundle("artifacts/model_bundle.rds")
# bundle$model, bundle$features, bundle$metrics
```

**Bundle structure:**
```r
list(
  model = <ranger object>,
  features = c("claim_amount", "policy_age_days", ...),
  metrics = list(auc = 0.8713),
  timestamp = "2026-08-07 00:08:54"
)
```

---

### `pipeline.R` — End-to-End Training

**Function:** `run_training_pipeline(config_path)`

Orchestrates the entire training workflow:

```
Generate Data → Create Features → Train/Test Split → Train Model → Evaluate → Save Bundle
```

**Usage:**
```r
metrics <- run_training_pipeline("config/config.yml")
# Logs: "Model AUC: 0.871351351351351"
```

---

### `logging.R` — Logger Setup

**Function:** `setup_logger()`

Configures the `logger` package for structured logging.

---

### `monitor.R` — Monitoring Utilities

Placeholder for production monitoring (latency, throughput, drift detection).

---

### `explain.R` — Model Explainability

Placeholder for SHAP values and variable importance plots.

---

### `utils.R` — Helper Functions

Miscellaneous utility functions used across modules.

---

## Design Principles

1. **Single Responsibility** — Each file does one thing well
2. **R6 Encapsulation** — State and behavior bundled in classes
3. **Pure Functions** — No side effects unless explicitly named
4. **Defensive Programming** — Validation at every boundary
