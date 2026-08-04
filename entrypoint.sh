#!/bin/bash
set -e

echo "Starting virtual display on ${DISPLAY} (${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_DEPTH})..."
Xvfb "${DISPLAY}" -screen 0 "${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_DEPTH}" -ac +extension GLX +render -noreset &
XVFB_PID=$!

cleanup() {
    kill "$XVFB_PID" 2>/dev/null || true
}
trap cleanup EXIT

# Wait for the display to actually accept connections instead of guessing
# with a fixed sleep — Chrome will fail to start a session if it races
# ahead of Xvfb being ready.
echo "Waiting for X server to be ready..."
for i in $(seq 1 20); do
    if xdpyinfo -display "${DISPLAY}" >/dev/null 2>&1; then
        echo "X server is ready."
        break
    fi
    if [ "$i" -eq 20 ]; then
        echo "X server did not become ready in time." >&2
        exit 1
    fi
    sleep 0.5
done

echo "Running: $*"
exec "$@"