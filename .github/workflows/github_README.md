# 🔄 .github/workflows/ — CI/CD

GitHub Actions workflows for automated testing and deployment.

---

## Files

### `ci.yml` — Continuous Integration

Runs the test suite on every push and pull request.

**Triggers:**
- Push to `main` branch
- Pull request to `main` branch

**Steps:**
1. Checkout code
2. Setup R environment
3. Install dependencies
4. Run tests

---

## Future Workflows

| Workflow | Purpose |
|----------|---------|
| `cd.yml` | Deploy API to production |
| `docker.yml` | Build and push Docker image |
| `lint.yml` | Code style checks (lintr) |
| `coverage.yml` | Test coverage reporting |
