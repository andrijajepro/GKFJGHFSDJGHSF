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
    curl

# Set the working directory
WORKDIR /app

# Install noVNC
RUN wget -qO- https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz | tar xz --strip 1 -C /app \
    && mv vnc_lite.html index.html

# Expose port 8080 for noVNC
EXPOSE 8080

# Start Xvfb and fluxbox
CMD Xvfb :1 -screen 0 1024x768x16 & fluxbox -display :1 & x11vnc -display :1 -nopw -listen localhost -xkb -forever -shared -rfbport 5901 && websockify --web /app 8080 localhost:5901
