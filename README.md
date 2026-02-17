# Personal OpenClaw Docker Image

[![Docker](https://github.com/jinglemansweep/openclaw-docker/actions/workflows/docker.yml/badge.svg)](https://github.com/jinglemansweep/openclaw-docker/actions/workflows/docker.yml)

Personal OpenClaw Docker image with pre-installed development tools, utilities, and browser automation.

## Usage

The compose file automatically runs as your current user to avoid permission issues with mounted volumes.

### Setup

Create a `.env` file from the example:

```bash
# Copy example
cp .env.example .env

# Edit .env and add any configuration and secrets
nano .env  # or vim, code, etc.
```

**Important**: The `.env` file usually contains secrets and is git-ignored

### Usage

```bash
# Build and run (or pull if image exists)
docker-compose up -d

# Enter the container
docker-compose exec openclaw bash
```
