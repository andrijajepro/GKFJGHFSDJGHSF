# Use the latest Ubuntu image
FROM ubuntu:latest

# Set noninteractive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    novnc \
    websockify \
    x11vnc \
    fluxbox \
    xvfb \
    supervisor \
    wget \
    curl \
    net-tools \
    xterm

# Set the working directory
WORKDIR /app

# Install noVNC
RUN wget -qO- https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz | tar xz --strip 1 -C /app \
    && mv vnc_lite.html index.html

# Expose port 8080 for noVNC
EXPOSE 8080

# Start Xvfb, Fluxbox, x11vnc, and WebSockify
CMD Xvfb :1 -screen 0 1024x768x16 +extension RANDR & \
    echo "Waiting for Xvfb to start..." && sleep 5 && \
    fluxbox -display :1 & \
    echo "Starting Fluxbox..." && \
    x11vnc -display :1 -nopw -listen localhost -xkb -forever -shared -rfbport 5900 & \
    echo "Starting x11vnc..." && \
    sleep 5 && \
    xterm -display :1 -geometry 100x30+0+0 -e echo "X11vnc is running on display :1" & \
    echo "Starting WebSockify..." && \
    websockify --web /app 8080 localhost:5900
