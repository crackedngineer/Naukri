FROM ubuntu:22.04

LABEL description="Naukri Selenium bot with Chrome, Xvfb and Supercronic"

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:99 \
    SCREEN_WIDTH=1920 \
    SCREEN_HEIGHT=1080 \
    SCREEN_DEPTH=24 \
    PYTHONUNBUFFERED=1 \
    WDM_LOCAL=1 \
    SUPERCRONIC_VERSION=v0.2.33

RUN apt-get update && apt-get install -y --no-install-recommends \
        wget \
        curl \
        bash \
        ca-certificates \
        xvfb \
        x11-utils \
        python3 \
        python3-pip \
        fonts-liberation \
        libnss3 \
        libgconf-2-4 \
        libgbm1 \
        libasound2 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libcups2 \
        libxcomposite1 \
        libxdamage1 \
        libxfixes3 \
        libxrandr2 \
        libxkbcommon0 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libgtk-3-0 \
        libxss1 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL \
    "https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-amd64" \
    -o /usr/local/bin/supercronic \
    && chmod +x /usr/local/bin/supercronic \
    && /usr/local/bin/supercronic -version

RUN wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends /tmp/chrome.deb \
    && rm /tmp/chrome.deb \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY naukri.py constants.py ./
COPY crontab cron.sh ./

COPY entrypoint.sh /entrypoint.sh

RUN sed -i 's/\r$//' /entrypoint.sh \
    && chmod +x /entrypoint.sh \
    && chmod +x /app/cron.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["supercronic", "/app/crontab"]