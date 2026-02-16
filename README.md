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

```yaml
version: '3'
services:
  openclaw:
    image: openclaw-extended
    volumes:
      - ./workspace:/workspace
    ports:
      - "8080:8080"
```

## GitHub Container Registry

This image is automatically built and published to GitHub Container Registry on push to main or on tagged releases.

```bash
docker pull ghcr.io/jinglemansweep/openclaw-docker:latest
```
