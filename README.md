# openclaw-docker

Personal OpenClaw Docker image with pre-installed development tools, utilities, and browser automation.

## Overview

This Docker image extends the official OpenClaw image (`alpine/openclaw` - which is actually **Debian 12 Bookworm** based) with a comprehensive set of development tools, debugging utilities, browser automation (Playwright + Chromium), and common packages to provide a full-featured development environment.

## Included Tools & Packages

### Build Tools
- `build-essential`, `cmake`, `ninja-build`
- `pkg-config`, `autoconf`, `automake`, `libtool`

### Version Control
- `git`, `git-lfs`, `subversion`, `mercurial`

### Text Editors
- `vim`, `nano`, `emacs-nox`

### Shell & Terminal
- `bash-completion`, `zsh`, `fish`
- `tmux`, `screen`

### Network Tools
- `curl`, `wget`, `httpie`
- `netcat`, `telnet`, `nmap`
- `ping`, `traceroute`, `dnsutils`

### System Utilities
- `htop`, `iotop`, `glances`
- `ncdu`, `tree`, `file`
- `strace`, `ltrace`, `lsof`

### Modern CLI Tools
- `ripgrep` (rg) - Fast grep alternative
- `fd-find` (fd) - Fast find alternative
- `silversearcher-ag` (ag) - Code search tool
- `fzf` - Fuzzy finder
- `bat` - Cat with syntax highlighting
- `exa` - Modern ls replacement
- `jq` - JSON processor

### Debugging Tools
- `gdb`, `gdbserver`, `valgrind`

### Compression
- `zip`, `unzip`, `bzip2`, `xz-utils`, `p7zip-full`

### Development Libraries
- OpenSSL, cURL, zlib, bzip2, readline, SQLite, FFI, LZMA

### Python
- Python 3 with pip, venv, and common packages
- **pipx** - Install and run Python applications in isolated environments

### Browser Automation
- **Playwright** - Modern browser automation framework
- **Chromium** - Full Chromium browser with ChromeDriver
- Playwright browsers: Chromium, Firefox, WebKit
- Font support for internationalization

### Node.js & JavaScript
- Node.js runtime
- npm package manager
- **clawhub** - Pre-installed with sonoscli

### Multimedia
- **ffmpeg** - Complete multimedia processing toolkit

## Key Features

- ✨ **Debian 12 (Bookworm) base** - Stable and well-supported
- 🎭 **Playwright** - Browser automation with Chromium, Firefox, and WebKit
- 🛠️ **50+ development tools** - Everything from build tools to modern CLI utilities
- 🐍 **Python 3** with pip and common packages
- 📦 **Node.js LTS & npm** for JavaScript development
- 🔧 **Full build environment** - gcc, cmake, ninja, and more

## Building

```bash
docker build -t openclaw-extended .
```

## Running

```bash
docker run -it --rm openclaw-extended
```

## Using Playwright

The image comes with Playwright and Chromium pre-installed:

```python
# Python example
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page()
    page.goto('https://example.com')
    print(page.title())
    browser.close()
```

```javascript
// Node.js example
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto('https://example.com');
  console.log(await page.title());
  await browser.close();
})();
```

## Usage with Docker Compose

The compose file automatically runs as your current user to avoid permission issues with mounted volumes.

### Setup

Create a `.env` file from the example:

```bash
# Copy example
cp .env.example .env

# Edit .env and add your Discord token
nano .env  # or vim, code, etc.
```

**Important**: The `.env` file contains secrets and is git-ignored. Never commit it!

Your `.env` file should look like:

```bash
# User/Group (auto-detected if not set)
UID=1000
GID=1000

# Discord Bot Token (required for OpenClaw)
DISCORD_TOKEN=your_discord_bot_token_here
```

Get your Discord token from: https://discord.com/developers/applications

### Usage

```bash
# Build and run (or pull if image exists)
docker-compose up -d

# Enter the container
docker-compose exec openclaw bash

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

### Data Directories

The compose file creates two volume mounts in `./data/`:

- `./data/workspace` - Your working files (mapped to `/home/node/.openclaw/workspace`)
- `./data/state` - OpenClaw configuration and state (mapped to `/home/node/.openclaw`)

### Configuration

OpenClaw reads the `DISCORD_TOKEN` environment variable automatically. You can:

**Option 1**: Use `.env` file (recommended for local development)
```bash
echo "DISCORD_TOKEN=your_token_here" >> .env
docker-compose up -d
```

**Option 2**: Export environment variable
```bash
export DISCORD_TOKEN=your_token_here
docker-compose up -d
```

**Option 3**: Inline with docker-compose
```bash
DISCORD_TOKEN=your_token_here docker-compose up -d
```

If OpenClaw also reads from `data/state/openclaw.json`, the environment variable will take precedence.

## GitHub Container Registry

This image is automatically built and published to GitHub Container Registry on push to main or on tagged releases.

### Pull Pre-built Image

```bash
# Pull latest
docker pull ghcr.io/jinglemansweep/openclaw-docker:latest

# Run directly
docker run -it --rm ghcr.io/jinglemansweep/openclaw-docker:latest

# Or use Docker Compose (see above)
docker-compose --profile ghcr up -d
```

### Available Tags

- `latest` - Latest build from main branch
- `main` - Alias for latest
- `sha-<commit>` - Specific commit builds
- `v*` - Version tags (e.g., `v1.0.0`, `v1.0`)
