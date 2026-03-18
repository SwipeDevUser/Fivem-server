# Infrastructure Directory

Deployment, containerization, and infrastructure-as-code files.

## Contents

### docker/
- `Dockerfile` - FiveM server container image
- `Dockerfile.admin` - Admin portal container image
- `docker-compose.yml` (in root) - Complete stack orchestration

### terraform/
- Infrastructure-as-code for cloud deployment (AWS, Azure, GCP)
- Optional: Use if deploying to cloud

### scripts/
- `deploy.sh` - One-command deployment
- `backup.sh` - Automated database backups
- Other operational scripts

## Quick Start

```bash
# Deploy entire platform
./infrastructure/scripts/deploy.sh

# View status
docker-compose ps

# View logs
docker-compose logs -f
```

See `/docs/operations/` for detailed guides.
