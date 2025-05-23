# Dev Container Configuration

This project uses pre-built Docker images for fast GitHub Codespace startup.

## Available Configurations

### `devcontainer.json` (Default - Recommended)
- Uses pre-built image from GitHub Container Registry
- **Startup time**: ~30-60 seconds
- **Best for**: Regular development work

### `devcontainer-build.json` (Alternative)
- Uses pre-built image with build context
- **Startup time**: ~30-60 seconds  
- **Best for**: Testing latest changes

### `devcontainer-local.json` (Fallback)
- Builds from local Dockerfile
- **Startup time**: ~5-10 minutes
- **Best for**: Emergency use if pre-built image unavailable

## Image Building

Docker images are automatically built and pushed to GitHub Container Registry:
- **Trigger**: Push to main branch, weekly schedule, manual dispatch
- **Registry**: `ghcr.io/nemogb-dev/nemogb-app:latest`
- **Workflow**: `.github/workflows/docker-build.yml`

## Quick Start

1. Create Codespace using default configuration
2. Wait ~30-60 seconds for container startup
3. Start developing immediately

## Troubleshooting

If Codespace fails to start:
1. Check if image build is successful in GitHub Actions
2. Use `devcontainer-local.json` as fallback option
3. Manually trigger image rebuild via GitHub Actions

## Local Development

For local development, continue using:
```bash
docker-compose up
```

This maintains volume mounts for live code editing.
