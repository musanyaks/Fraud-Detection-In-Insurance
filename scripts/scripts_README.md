# 🚀 scripts/ — Operational Scripts

This directory contains the **executable scripts** that run the fraud detection pipeline.

---

## Scripts

### `01_generate_data.R` — Generate Synthetic Claims

**Purpose:** Create training data with realistic fraud patterns.

**What it does:**
1. Loads configuration from `config/config.yml`
2. Generates `n_claims` synthetic insurance claims
3. Injects fraud patterns (high amount + new policy, provider risk)
4. Saves to `data/claims_raw.csv`

**Usage:**
```bash
Rscript scripts/01_generate_data.R
```

**Output:**
```
Data generated and saved to data/claims_raw.csv
```

**Prerequisites:**
- `config/config.yml` exists
- `data/` directory exists (create with `mkdir data`)

---

### `02_train.R` — Train the Model

**Purpose:** Run the full training pipeline.

**What it does:**
1. Generates fresh synthetic data
2. Creates engineered features
3. Splits into 80% train / 20% test
4. Trains Random Forest model
5. Evaluates on test set (AUC)
6. Saves model bundle to `artifacts/model_bundle.rds`

**Usage:**
```bash
Rscript scripts/02_train.R
```

**Output:**
```
INFO [2026-08-07 00:08:52] Starting training pipeline
INFO [2026-08-07 00:08:54] Model AUC: 0.871351351351351
INFO [2026-08-07 00:08:54] Pipeline completed successfully
```

**Prerequisites:**
- All R packages installed (`dplyr`, `ranger`, `pROC`, `logger`, etc.)
- `config/config.yml` exists
- `artifacts/` directory exists (create with `mkdir artifacts`)

---

### `04_serve_api.R` — Start API Server

**Purpose:** Launch the REST API for real-time fraud scoring.

**What it does:**
1. Loads required packages (`dplyr`, `ranger`, `plumber`)
2. Sources all R modules
3. Loads configuration
4. Loads trained model bundle from `artifacts/`
5. Starts Plumber server on `http://0.0.0.0:8000`

**Usage:**
```bash
Rscript scripts/04_serve_api.R
```

**Output:**
```
Running plumber API at http://0.0.0.0:8000
Running swagger Docs at http://127.0.0.1:8000/__docs__/
```

**Prerequisites:**
- Model bundle exists at `artifacts/model_bundle.rds` (run `02_train.R` first)
- `config/config.yml` exists

**Stopping:**
Press `Ctrl + C` in the terminal.

---

## Script Numbering Convention

| Number | Script | Purpose |
|--------|--------|---------|
| `01_` | Data generation | Create raw data |
| `02_` | Training | Train and save model |
| `04_` | Serving | Start API server |

> **Note:** `03_` is reserved for future scripts (e.g., batch scoring, model retraining).

---

## Running All Scripts

```bash
# 1. Setup directories
mkdir -p data artifacts models logs

# 2. Generate data
Rscript scripts/01_generate_data.R

# 3. Train model
Rscript scripts/02_train.R

# 4. Start API (runs until stopped)
Rscript scripts/04_serve_api.R
```

---

## Troubleshooting

### "could not find function '%>%'"
**Fix:** Add `library(dplyr)` at the top of the script.

### "cannot open file 'data/claims_raw.csv': No such file or directory"
**Fix:** Create the directory: `mkdir data`

### "cannot open compressed file 'artifacts/model_bundle.rds'"
**Fix:** Create the directory: `mkdir artifacts`

### "no applicable method for 'predict' applied to an object of class 'ranger'"
**Fix:** Add `library(ranger)` at the top of the script.

### "Rscript: command not found"
**Fix:** Add R to your PATH or use the full path:
```bash
"/c/Program Files/R/R-4.4.1/bin/Rscript" scripts/02_train.R
```
