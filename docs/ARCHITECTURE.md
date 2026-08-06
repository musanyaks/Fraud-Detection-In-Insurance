# Architecture: Insurance Fraud Detection System

## Components

1.  **Data Generation (`R/data_gen.R`)**: Creates synthetic insurance claims with embedded fraud patterns for training and testing.
2.  **Schema & Validation (`R/schema.R`)**: R6-based validation of incoming claim data to ensure data integrity before scoring.
3.  **Feature Engineering (`R/features.R`)**: Transforms raw claim data into features suitable for the ML model (e.g., policy age, provider risk).
4.  **Hybrid Rule Engine (`R/fraud_rules.R`)**: A deterministic rule-based system that flags obvious fraud indicators, providing explainable "red flags" alongside the ML score.
5.  **ML Model (`R/train.R`)**: Uses the `ranger` package (Random Forest) for robust classification of fraud vs. non-fraud.
6.  **Model Registry (`R/registry.R`)**: Manages model versioning and bundling, including the model object, feature lists, and performance metrics.
7.  **API (`api/plumber.R`)**: A RESTful API built with Plumber to serve predictions in real-time.

## Workflow

1.  **Training**: Run `scripts/02_train.R` to process raw data, train the Random Forest model, evaluate it, and save the model bundle to `artifacts/`.
2.  **Serving**: `scripts/04_serve_api.R` starts the Plumber server, loads the latest model bundle, and listens for incoming scoring requests.
3.  **Inference**: The `/predict` endpoint receives a JSON claim, validates it, creates features, runs both the ML model and the rule engine, and returns a combined decision.
