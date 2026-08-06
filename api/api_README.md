# 🌐 api/ — REST API

This directory contains the **Plumber** REST API that serves fraud predictions in real-time.

---

## What is Plumber?

[Plumber](https://www.rplumber.io/) is an R package that converts your R code into a REST API by adding special **roxygen2-style comments** (`#*`).

---

## Files

### `plumber.R` — Route Definitions

Defines the API endpoints using Plumber annotations:

```r
#* @get /health
function() {
  handle_health()
}

#* @post /predict
function(req, res) {
  handle_predict(req, res, .globals$model_bundle)
}
```

| Annotation | Meaning |
|------------|---------|
| `#* @get /health` | HTTP GET endpoint at `/health` |
| `#* @post /predict` | HTTP POST endpoint at `/predict` |

---

### `request_handlers.R` — Business Logic

Contains the actual request processing functions:

#### `handle_predict(req, res, model_bundle)`

1. **Parse JSON** from request body
2. **Validate** claim data using `ClaimSchema`
3. **Predict** fraud using `predict_fraud()`
4. **Return** JSON response

**Error handling:**
- Invalid JSON → `400 Bad Request`
- Validation failure → `400 Bad Request` with error message
- Server error → `500 Internal Server Error`

#### `handle_health()`

Returns system health status:
```json
{
  "status": ["alive"],
  "timestamp": ["2026-08-07 00:19:28"]
}
```

---

### `startup.R` — API Initialization

Runs once when the API server starts:

1. **Sources** all R modules from `R/`
2. **Loads** configuration from `config/config.yml`
3. **Loads** the trained model bundle from `artifacts/`
4. **Stores** model in global environment `.globals$model_bundle`

**Why global?** Plumber handlers are stateless functions. The model bundle is loaded once at startup and shared across all requests.

---

## Running the API

### Development

```bash
Rscript scripts/04_serve_api.R
```

**Output:**
```
Running plumber API at http://0.0.0.0:8000
Running swagger Docs at http://127.0.0.1:8000/__docs__/
```

### Production

```bash
# With specific host/port
Rscript -e "pr <- plumber::plumb('api/plumber.R'); pr$run(host='0.0.0.0', port=8000)"
```

---

## API Endpoints

### `GET /health`

**Purpose:** Check if the API is running and the model is loaded.

**Request:**
```bash
curl http://localhost:8000/health
```

**Response:**
```json
{
  "status": ["alive"],
  "timestamp": ["2026-08-07 00:19:28"]
}
```

**Status Codes:**
| Code | Meaning |
|------|---------|
| 200 | API is healthy |

---

### `POST /predict`

**Purpose:** Score an insurance claim for fraud.

**Request:**
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

**Required Fields:**
| Field | Type | Constraints |
|-------|------|-------------|
| `claim_amount` | numeric | >= 0 |
| `policy_age_days` | integer | >= 0 |
| `claimant_age` | integer | >= 18 |
| `history_claims_count` | integer | >= 0 |
| `provider_risk_score` | numeric | 0–100 |

**Response (Success):**
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

**Response (Error):**
```json
{
  "error": "Invalid JSON"
}
```

**Status Codes:**
| Code | Meaning |
|------|---------|
| 200 | Prediction successful |
| 400 | Invalid request (bad JSON or validation failed) |
| 500 | Internal server error |

---

## Swagger UI

Plumber auto-generates interactive API documentation at:

```
http://localhost:8000/__docs__/
```

Features:
- 📖 Browse all endpoints
- 🧪 Test requests interactively
- 📋 View request/response schemas
- 💾 Download OpenAPI spec

---

## Testing the API

### Using curl

```bash
# Health check
curl http://localhost:8000/health

# Predict (low risk)
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"claim_amount":2000,"policy_age_days":1000,"claimant_age":45,"history_claims_count":0,"provider_risk_score":20}'

# Predict (high risk)
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"claim_amount":95000,"policy_age_days":2,"claimant_age":25,"history_claims_count":5,"provider_risk_score":95}'
```

### Using R

```r
library(httr)

response <- POST(
  "http://localhost:8000/predict",
  body = list(
    claim_amount = 50000,
    policy_age_days = 5,
    claimant_age = 45,
    history_claims_count = 3,
    provider_risk_score = 85
  ),
  encode = "json"
)

content(response)
```

### Using Python

```python
import requests

response = requests.post(
    "http://localhost:8000/predict",
    json={
        "claim_amount": 50000,
        "policy_age_days": 5,
        "claimant_age": 45,
        "history_claims_count": 3,
        "provider_risk_score": 85
    }
)
print(response.json())
```

---

## Architecture Notes

- **Stateless handlers** — Each request is independent
- **Global model bundle** — Loaded once at startup, shared across requests
- **JSON in/out** — Standard REST format
- **Validation layer** — Schema validation before scoring
- **Error boundaries** — Try-catch blocks prevent server crashes
