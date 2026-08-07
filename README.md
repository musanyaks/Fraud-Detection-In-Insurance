# 🛡️ Insurance Fraud Detection System

An end-to-end machine learning system for detecting fraudulent insurance claims, built in **R** with a production-ready **REST API**.

[![R](https://img.shields.io/badge/R-4.4+-276DC3?logo=r)](https://www.r-project.org/)
[![Plumber](https://img.shields.io/badge/API-Plumber-009999?logo=r)](https://www.rplumber.io/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage](#usage)
  - [1. Generate Data](#1-generate-data)
  - [2. Train Model](#2-train-model)
  - [3. Serve API](#3-serve-api)
  - [4. Make Predictions](#4-make-predictions)
- [API Documentation](#api-documentation)
- [Architecture](#architecture)
- [Configuration](#configuration)
- [Testing](#testing)
- [Docker](#docker)
- [Contributing](#contributing)
- [License](#license)

---

##  Overview

This project implements a **hybrid fraud detection engine** that combines:

-  **Machine Learning** — Random Forest classifier (`ranger`) for probabilistic fraud scoring
-  **Rule Engine** — Deterministic business rules for explainable red flags
-  **Feature Engineering** — Automated transformation of raw claims into model-ready features
-  **REST API** — Real-time scoring via Plumber with Swagger UI

**Model Performance:** AUC ~0.87 on synthetic test data

---

##  Features

| Feature | Description |
|---------|-------------|
|  **ML Prediction** | Random Forest probability scores for fraud likelihood |
|  **Rule Flags** | Explainable rules: high amount + new policy, provider risk, multiple claims |
|  **Real-time API** | Sub-second scoring via REST endpoints |
|  **Synthetic Data** | Built-in data generator with realistic fraud patterns |
|  **R6 Architecture** | Object-oriented design for config, schema, and model registry |
|  **Model Registry** | Versioned model bundles with metadata and metrics |
|  **Input Validation** | Schema validation for all incoming claims |
|  **Docker Ready** | Containerized deployment support |
|  **CI/CD** | GitHub Actions workflow for automated testing |

---

## 🗂️ Project Structure

```
Fraud-Detection-In-Insurance/
│
├── 📁 R/                          # Core R package modules
│   ├── config.R                   # AppConfig R6 class (YAML config loader)
│   ├── data_gen.R                 # Synthetic claims data generator
│   ├── features.R                 # Feature engineering pipeline
│   ├── train.R                    # Random Forest model training (ranger)
│   ├── evaluate.R                 # Model evaluation (AUC, ROC)
│   ├── fraud_rules.R              # Hybrid rule engine for red flags
│   ├── serve.R                    # Prediction & decision logic
│   ├── schema.R                   # ClaimSchema R6 validation class
│   ├── registry.R                 # ModelRegistry R6 (save/load bundles)
│   ├── pipeline.R                 # End-to-end training pipeline
│   ├── logging.R                  # Logger setup utilities
│   ├── monitor.R                  # Monitoring utilities
│   ├── explain.R                  # Model explainability (SHAP/variable importance)
│   └── utils.R                    # Helper functions
│
├── 📁 api/                        # Plumber REST API
│   ├── plumber.R                  # API route definitions
│   ├── request_handlers.R         # HTTP request handlers
│   └── startup.R                  # API initialization (load model, config)
│
├── 📁 scripts/                    # Operational scripts
│   ├── 01_generate_data.R         # Generate raw claims data
│   ├── 02_train.R                 # Run full training pipeline
│   └── 04_serve_api.R             # Start the API server
│
├── 📁 config/                     # Configuration files
│   └── config.yml                 # App settings (paths, model params, data params)
│
├── 📁 tests/                      # Unit tests (testthat)
│   └── testthat/
│       └── test-data_gen.R        # Data generation tests
│
├── 📁 docs/                       # Documentation
│   └── ARCHITECTURE.md            # System architecture details
│
├── 📁 docker/                     # Docker deployment
│   └── Dockerfile                 # Container definition
│
├── 📁 .github/workflows/          # CI/CD
│   └── ci.yml                     # GitHub Actions test runner
│
├── DESCRIPTION                    # R package metadata
├── NAMESPACE                      # R package exports
├── Makefile                       # Build automation
├── .gitignore                     # Git ignore rules
├── .Rbuildignore                  # R build ignore rules
└── README.md                      # This file
```

---

##  Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/musanyaks/Fraud-Detection-In-Insurance.git
cd Fraud-Detection-In-Insurance

# 2. Install R dependencies
Rscript -e "install.packages(c('dplyr', 'ranger', 'pROC', 'plumber', 'R6', 'yaml', 'logger', 'vip', 'checkmate', 'jsonlite', 'testthat'))"

# 3. Create required directories
mkdir -p data artifacts models logs

# 4. Generate data & train model
Rscript scripts/01_generate_data.R
Rscript scripts/02_train.R

# 5. Start the API
Rscript scripts/04_serve_api.R

# 6. Test the API
curl http://localhost:8000/health
```

---

## 📦 Installation

### Prerequisites

- **R** >= 4.4.0 ([Download](https://cran.r-project.org/))
- **Rscript** in your system PATH

### Install Dependencies

```r
# In R console or Rscript
install.packages(c(
  "dplyr", "ranger", "pROC", "plumber", "R6", "yaml",
  "logger", "vip", "checkmate", "jsonlite", "testthat",
  "purrr", "tidyr", "rlang", "data.table"
))
```

Or install as an R package:

```r
# From the project root
devtools::install_deps()
```

### Verify Installation

```bash
Rscript -e "library(dplyr); library(ranger); library(plumber); cat('All packages loaded!\n')"
```

---

##  Usage

### 1. Generate Data

Creates synthetic insurance claims with embedded fraud patterns.

```bash
Rscript scripts/01_generate_data.R
```

**Output:** `data/claims_raw.csv`

**Columns:**
| Column | Description |
|--------|-------------|
| `claim_id` | Unique claim identifier |
| `claim_amount` | Claim amount in dollars |
| `policy_age_days` | Days since policy inception |
| `claimant_age` | Age of the claimant |
| `history_claims_count` | Number of past claims |
| `provider_risk_score` | Risk score of the provider (0-100) |
| `is_fraud` | Ground truth fraud label (0/1) |

### 2. Train Model

Runs the full training pipeline: data generation → feature engineering → train/test split → model training → evaluation → save bundle.

```bash
Rscript scripts/02_train.R
```

**Output:**
- `artifacts/model_bundle.rds` — Serialized model with metadata
- Console logs with AUC score

**Pipeline Steps:**
1. Generate synthetic claims
2. Create engineered features
3. 80/20 train/test split
4. Train Random Forest (500 trees)
5. Evaluate AUC on test set
6. Save model bundle to registry

### 3. Serve API

Starts the Plumber REST API server.

```bash
Rscript scripts/04_serve_api.R
```

**Endpoints:**
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check + timestamp |
| POST | `/predict` | Score a claim for fraud |

**Swagger UI:** http://localhost:8000/__docs__/

### 4. Make Predictions

#### Using curl

```bash
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{
    "claim_amount": 50000,
    "policy_age_days": 5,
    "claimant_age": 45,
    "history_claims_count": 3,
    "provider_risk_score": 85
  }'
```

#### Using Swagger UI

1. Open http://localhost:8000/__docs__/
2. Click `POST /predict` → **Try it out**
3. Paste the JSON above
4. Click **Execute**

#### Example Response

```json
{
  "probability": [0.4364],
  "rules": [
    {
      "high_amount_new_policy": true,
      "very_high_provider_risk": false,
      "multiple_recent_claims": false,
      "any_rule_hit": true
    }
  ],
  "decision": ["Review"]
}
```

**Response Fields:**
| Field | Description |
|-------|-------------|
| `probability` | Fraud probability (0-1) from ML model |
| `rules` | Rule engine flags (explainable red flags) |
| `decision` | Final decision: `"Approve"`, `"Review"`, or `"Fraud"` |

---

## 📡 API Documentation

### `GET /health`

Health check endpoint.

**Response:**
```json
{
  "status": ["alive"],
  "timestamp": ["2026-08-07 00:19:28"]
}
```

### `POST /predict`

Score a single insurance claim for fraud.

**Request Body:**
```json
{
  "claim_amount": 50000,
  "policy_age_days": 5,
  "claimant_age": 45,
  "history_claims_count": 3,
  "provider_risk_score": 85
}
```

**Validation Rules:**
- `claim_amount` >= 0 (numeric)
- `policy_age_days` >= 0 (integer)
- `claimant_age` >= 18 (integer)

**Response Codes:**
| Code | Meaning |
|------|---------|
| 200 | Success — prediction returned |
| 400 | Bad Request — invalid JSON or validation failed |
| 500 | Internal Server Error — model or system error |

---

##  Architecture

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for detailed system design.

### High-Level Flow

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Raw Claim  │────▶│   Schema     │────▶│   Feature   │
│   (JSON)     │     │  Validation  │     │ Engineering │
└─────────────┘     └──────────────┘     └──────┬──────┘
                                                  │
                       ┌──────────────────────────┘
                       ▼
              ┌─────────────────┐
              │  Random Forest  │
              │     Model       │──▶ probability
              │   (ranger)      │
              └─────────────────┘
                       │
                       ▼
              ┌─────────────────┐
              │   Rule Engine   │──▶ red flags
              │  (deterministic)│
              └─────────────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ Decision Logic  │──▶ Approve / Review / Fraud
              └─────────────────┘
```

### Key Design Decisions

- **Hybrid Approach:** ML for nuanced patterns + rules for explainable hard stops
- **R6 OOP:** Encapsulated config, schema, and registry classes
- **Model Bundles:** Self-contained artifacts with model + features + metrics
- **Plumber API:** Lightweight, native R REST framework

---

## ⚙️ Configuration

All settings are in `config/config.yml`:

```yaml
default:
  data:
    n_claims: 10000
    fraud_rate: 0.05
  model:
    target: "is_fraud"
    features: ["claim_amount", "policy_age_days", "claimant_age", "history_claims_count", "provider_risk_score"]
    params:
      num.trees: 500
      mtry: 3
  paths:
    data_raw: "data/claims_raw.csv"
    model_bundle: "artifacts/model_bundle.rds"
  seed: 42
```

| Section | Key | Description |
|---------|-----|-------------|
| `data` | `n_claims` | Number of synthetic claims to generate |
| `data` | `fraud_rate` | Base fraud rate in synthetic data |
| `model` | `target` | Target variable name |
| `model` | `features` | Feature columns for training |
| `model` | `params` | Random Forest hyperparameters |
| `paths` | `data_raw` | Raw data output path |
| `paths` | `model_bundle` | Saved model artifact path |
| `seed` | — | Random seed for reproducibility |

---

##  Testing

Run the test suite:

```bash
Rscript -e "testthat::test_dir('tests/testthat')"
```

Or use the Makefile:

```bash
make test
```

---

## 🐳 Docker

Build and run with Docker:

```bash
# Build image
docker build -t fraud-detection-api .

# Run container
docker run -p 8000:8000 fraud-detection-api
```

See [docker/README.md](docker/README.md) for details.

---

##  Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

---

##  License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

##  Support

If you encounter issues:

1. Check the [API logs](#3-serve-api) for error messages
2. Ensure all [dependencies](#installation) are installed
3. Verify `data/` and `artifacts/` directories exist
4. Open an issue on GitHub

---

**Built with Passion in R**
