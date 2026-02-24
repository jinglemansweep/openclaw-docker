ARG base_image=fourplayers/openclaw
ARG base_image_tag=latest

FROM ${base_image}:${base_image_tag}

LABEL maintainer="Louis King <jinglemansweep@gmail.com>"
LABEL description="Extended OpenClaw image with useful additional tools and skills pre-installed"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONUNBUFFERED=1

# Update and install common tools and packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Essentials
    build-essential ca-certificates cmake ninja-build \
    pkg-config autoconf automake libtool git git-lfs subversion \
    vim nano gnupg lsb-release \
    # Shell utilities
    bash-completion tmux screen curl wget netcat-openbsd telnet \
    nmap iputils-ping iproute2 dnsutils traceroute \
    # System utilities
    htop iotop ncdu tree file strace ltrace lsof \
    psmisc procps sysstat \
    # Compression tools
    zip unzip bzip2 xz-utils p7zip-full \
    # Development libraries
    libssl-dev libcurl4-openssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev libffi-dev liblzma-dev \
    # Programming languages and tools
    python3 python3-pip python3-venv python3-dev pipx \
    # Debugging tools
    gdb gdbserver valgrind \
    # Documentation and help
    man-db manpages manpages-dev \
    # Misc utilities
    bc jq ripgrep fd-find ffmpeg silversearcher-ag fzf \
    # Display and browser dependencies for Playwright
    fonts-liberation fonts-noto-color-emoji \
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

# Install Python tools (pipx)
RUN pipx install httpie && \
    pipx install glances && \
    pipx install yt-dlp
        
# Install Playwright's bundled Chromium to a system-wide path
RUN mkdir -p /ms-playwright && \
    npm install -g playwright && \
    playwright install chromium && \
    chmod -R 755 /ms-playwright

# Install GitHub CLI
RUN mkdir -p -m 755 /etc/apt/keyrings && \
	wget -nv -O /tmp/github-keyring.gpg https://cli.github.com/packages/githubcli-archive-keyring.gpg && \
	cat /tmp/github-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
	chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
	mkdir -p -m 755 /etc/apt/sources.list.d && \
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
	apt-get update && \
	apt-get install -y gh

# Set environment variables
ENV PATH=${PATH}:/home/node/.local/bin \
    PLAYWRIGHT_BROWSERS_PATH=/ms-playwright \
    OPENCLAW_HOME=/home/node/.openclaw \
    OPENCLAW_STATE_DIR=/home/node/.openclaw

# Install ClawHub skills
RUN mkdir -p /build/ext && cd /build/ext && \
    npx clawhub@latest install github && \
    npx clawhub@latest install gog && \
    npx clawhub@latest install topic-monitor

# Fix permissions
RUN chown -R node:node /home/node/.config /build/ext /ms-playwright

# Working directory and user
WORKDIR ${OPENCLAW_STATE_DIR}

