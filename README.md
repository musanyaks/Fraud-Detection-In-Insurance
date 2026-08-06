# Insurance Fraud Detection System

This project implements an end-to-end fraud detection system for insurance claims.

## Project Structure

- `R/`: Core logic (R6 classes for config, schema, model registry, etc.)
- `api/`: Plumber API definition and handlers.
- `scripts/`: Operational scripts for data generation, training, and serving.
- `tests/`: Unit tests using `testthat`.
- `config/`: Configuration files.

## Getting Started

### 1. Install Dependencies
Ensure you have the following R packages: `dplyr`, `ranger`, `pROC`, `plumber`, `R6`, `yaml`, `logger`, `vip`, `checkmate`.

### 2. Generate Data and Train
```bash
Rscript scripts/01_generate_data.R
Rscript scripts/02_train.R
```

### 3. Run the API
```bash
Rscript scripts/04_serve_api.R
```

## API Endpoints

- `GET /health`: Health check.
- `POST /predict`: Score a claim for fraud.
