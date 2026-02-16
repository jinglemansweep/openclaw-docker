FROM alpine/openclaw:latest

LABEL maintainer="Louis King <jinglemansweep@gmail.com>"
LABEL description="Extended OpenClaw image (Debian-based) with development tools, Playwright, and Chromium"

# Switch to root for package installation
USER root

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONUNBUFFERED=1 \
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=0 \
    PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# Update and install common tools and packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Build essentials
    build-essential cmake ninja-build pkg-config autoconf automake \
    libtool \
    # Version control
    git git-lfs subversion mercurial \
    # Text editors
    vim nano emacs-nox \
    # Shell utilities
    bash-completion zsh fish tmux screen \
    # Network tools
    curl wget netcat-openbsd telnet nmap iputils-ping iproute2 \
    dnsutils traceroute \
    # System utilities
    htop iotop ncdu tree file strace ltrace lsof psmisc procps \
    sysstat \
    # Compression tools
    zip unzip bzip2 xz-utils p7zip-full \
    # Development libraries
    libssl-dev libcurl4-openssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev libffi-dev liblzma-dev \
    # Programming languages and tools
    python3 python3-pip python3-venv python3-dev pipx ca-certificates \
    gnupg \
    # Multimedia
    ffmpeg \
    # Debugging tools
    gdb gdbserver valgrind \
    # Documentation and help
    man-db manpages manpages-dev \
    # Misc utilities
    bc jq ripgrep fd-find silversearcher-ag fzf \
    # Chromium and dependencies for Playwright
    chromium chromium-driver chromium-sandbox fonts-liberation fonts-noto-color-emoji \
    fonts-wqy-zenhei libatk-bridge2.0-0 libatk1.0-0 libcups2 \
    libdrm2 libgbm1 libgtk-3-0 libgtk-4-1 libnspr4 libnss3 \
    libxkbcommon0 libxshmfence1 xdg-utils \
    # GStreamer and WebKit dependencies
    libgstreamer1.0-0 libgstreamer-plugins-base1.0-0 \
    libgstreamer-plugins-bad1.0-0 gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
    gstreamer1.0-libav libgraphene-1.0-0 libavif15 \
    libharfbuzz-icu0 libmanette-0.2-0 libenchant-2-2 libhyphen0 \
    libsecret-1-0 libwoff1 libgles2 \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js from NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Create symbolic links for fd (naming conflict in Debian)
RUN ln -s $(which fdfind) /usr/local/bin/fd 2>/dev/null || true

# Install modern CLI and Python tools via pip
RUN pip3 install --no-cache-dir --break-system-packages \
    httpie glances yt-dlp speedtest-cli python-dotenv requests \
    playwright \
    && rm -rf ~/.cache/pip

# Install Playwright browsers (Chromium, Firefox, WebKit)
RUN playwright install chromium firefox webkit

# Set up Chromium as default for Playwright
ENV PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium

# Switch back to a non-root user
USER node
