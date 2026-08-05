# syntax=docker/dockerfile:1
FROM ubuntu:22.04

LABEL description="Naukri Selenium bot — real (non-headless) Chrome under a virtual display, GitHub Actions ready"

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:99 \
    SCREEN_WIDTH=1920 \
    SCREEN_HEIGHT=1080 \
    SCREEN_DEPTH=24 \
    PYTHONUNBUFFERED=1 \
    WDM_LOCAL=1

# ---- OS packages: virtual display + Chrome runtime deps + Python ----
RUN apt-get update && apt-get install -y --no-install-recommends \
        wget ca-certificates \
        xvfb x11-utils \
        python3 python3-pip \
        fonts-liberation libnss3 libgconf-2-4 \
        libgbm1 libasound2 libatk1.0-0 libatk-bridge2.0-0 libcups2 \
        libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libxkbcommon0 \
        libpango-1.0-0 libpangocairo-1.0-0 libgtk-3-0 libxss1 \
    && rm -rf /var/lib/apt/lists/*

# ---- Google Chrome ----
RUN wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends /tmp/chrome.deb \
    && rm /tmp/chrome.deb \
    && rm -rf /var/lib/apt/lists/*

# ---- Python dependencies ----
WORKDIR /app
COPY requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir -r /app/requirements.txt

# ---- App code ----
COPY naukri.py constants.py /app/
COPY entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r$//' /entrypoint.sh \
    && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["python3", "naukri.py"]