FROM python:3.11-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    xvfb \
    libxi6 \
    libgconf-2-4 \
    libnss3 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libgbm-dev \
    libasound2 \
    fonts-liberation \
    libappindicator3-1 \
    chromium \
    chromium-driver \
    && rm -rf /var/lib/apt/lists/*

# Set display for GUI
ENV DISPLAY=:99

# Install Python packages
RUN pip install --no-cache-dir selenium

# Create working dir
WORKDIR /app

# Copy your script
COPY . /app

# Start virtual display and run script
CMD Xvfb :99 -screen 0 1920x1080x24 & python naukri.py