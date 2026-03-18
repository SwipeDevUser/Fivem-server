# CI/CD Pipeline Directory

Continuous Integration and Continuous Deployment workflows.

## Contents

### github-actions/
GitHub Actions workflows for automated testing, building, and deployment.

## Workflows

### main.yml
Main CI/CD pipeline that:
1. **Test** - Linting, unit tests on pull requests
2. **Build** - Build Docker images
3. **Deploy** - Deploy to production on `main` branch

```yaml
Triggers:
- Push to main or develop
- Pull requests to main or develop

Jobs:
- test (lint, unit tests)
- build (Docker images)
- deploy (production only on main)
```

## Setup

### Enable GitHub Actions
1. Go to repository Settings → Actions
2. Ensure "Allow all actions and reusable workflows" is selected
3. Set repository secrets (if needed)

### Configure Secrets
In repository settings → Secrets:
- `DOCKER_HUB_USERNAME` (if pushing to Docker Hub)
- `DOCKER_HUB_TOKEN`
- `DEPLOY_KEY` (SSH key for deployment)
- `DATABASE_PASSWORD`

## Running Locally

```bash
# Install act (GitHub Actions local runner)
brew install act

# Run workflow
act push

# Run specific job
act push --job build
```

## Troubleshooting

```bash
# View Actions logs
# GitHub → Actions tab → Select workflow → View logs

# Re-run failed job
# Click "Re-run jobs" on failed workflow

# Debug mode
# Set secret: DEBUG=true
```

## Advanced Configuration

### Adding New Jobs
Edit `github-actions/main.yml`:
```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm run lint
```

### Environment Secrets
```yaml
env:
  DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

### Conditional Execution
```yaml
if: github.ref == 'refs/heads/main'
```

See `/docs/operations/` for CI/CD deployment guides.
