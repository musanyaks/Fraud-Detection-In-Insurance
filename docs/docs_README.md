# 📚 docs/ — Documentation

Additional documentation for the fraud detection system.

---

## Files

### `ARCHITECTURE.md` — System Architecture

Detailed technical documentation covering:

- **Component Overview** — What each module does
- **Data Flow** — How data moves through the system
- **Design Decisions** — Why certain technologies were chosen
- **Extensibility** — How to add new features

**Key topics:**
1. Data Generation (`R/data_gen.R`)
2. Schema & Validation (`R/schema.R`)
3. Feature Engineering (`R/features.R`)
4. Hybrid Rule Engine (`R/fraud_rules.R`)
5. ML Model (`R/train.R`)
6. Model Registry (`R/registry.R`)
7. REST API (`api/plumber.R`)

---

## Adding Documentation

To add new documentation:

1. Create a `.md` file in this directory
2. Link it from the main `README.md`
3. Follow Markdown best practices

**Suggested additions:**
- `DEPLOYMENT.md` — Production deployment guide
- `TROUBLESHOOTING.md` — Common issues and solutions
- `API_REFERENCE.md` — Detailed API documentation
- `CHANGELOG.md` — Version history
