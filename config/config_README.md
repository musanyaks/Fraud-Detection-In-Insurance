# ⚙️ config/ — Configuration

This directory contains application configuration files.

---

## Files

### `config.yml` — Main Configuration

YAML-based configuration for the fraud detection system.

```yaml
default:
  data:
    n_claims: 10000          # Number of synthetic claims to generate
    fraud_rate: 0.05         # Base fraud rate (5%)

  model:
    target: "is_fraud"       # Target variable name
    features:                # Feature columns for training
      - "claim_amount"
      - "policy_age_days"
      - "claimant_age"
      - "history_claims_count"
      - "provider_risk_score"
    params:                  # Random Forest hyperparameters
      num.trees: 500         # Number of trees
      mtry: 3                # Features per split (√5 ≈ 2.2, rounded to 3)

  paths:
    data_raw: "data/claims_raw.csv"
    model_bundle: "artifacts/model_bundle.rds"

  seed: 42                   # Random seed for reproducibility
```

---

## Configuration Sections

### `data`

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `n_claims` | integer | 10000 | Number of synthetic claims |
| `fraud_rate` | numeric | 0.05 | Base fraud probability |

### `model`

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `target` | string | "is_fraud" | Column to predict |
| `features` | list | [...] | Input feature columns |
| `params` | map | {...} | Ranger hyperparameters |

**Ranger Parameters:**
| Parameter | Default | Description |
|-----------|---------|-------------|
| `num.trees` | 500 | Number of trees in the forest |
| `mtry` | 3 | Variables randomly sampled at each split |

### `paths`

| Key | Default | Description |
|-----|---------|-------------|
| `data_raw` | "data/claims_raw.csv" | Raw data output path |
| `model_bundle` | "artifacts/model_bundle.rds" | Saved model path |

### `seed`

| Key | Default | Description |
|-----|---------|-------------|
| `seed` | 42 | Random seed for reproducible results |

---

## Loading Configuration

```r
cfg <- AppConfig$new("config/config.yml")

# Get nested values
cfg$get("data", "n_claims")        # 10000
cfg$get("model", "features")       # c("claim_amount", ...)
cfg$get("paths", "model_bundle")   # "artifacts/model_bundle.rds"
cfg$get("seed")                    # 42
```

---

## Customizing Configuration

### Increase dataset size
```yaml
data:
  n_claims: 50000
```

### Adjust fraud rate
```yaml
data:
  fraud_rate: 0.10  # 10% fraud
```

### Change model parameters
```yaml
model:
  params:
    num.trees: 1000
    mtry: 4
```

### Use different paths
```yaml
paths:
  data_raw: "data/v2/claims.csv"
  model_bundle: "models/fraud_v2.rds"
```

---

## Multiple Environments

You can define multiple config profiles:

```yaml
default:
  data:
    n_claims: 10000

production:
  data:
    n_claims: 100000
  model:
    params:
      num.trees: 1000

development:
  data:
    n_claims: 1000
```

Load a specific profile:
```r
cfg <- AppConfig$new("config/config.yml", config_name = "production")
```
