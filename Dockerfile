# Basisimage: Ubuntu 22.04 für ARM64 (Colima auf M1/M2 Mac)
FROM ubuntu:22.04

# Environment Variables
ENV DEBIAN_FRONTEND=noninteractive
ENV USERNAME=developer

# Install system dependencies (inkl. GUI und Python)
RUN apt-get update && apt-get install -y \
    python3 python3-pip \
    xfce4 xfce4-goodies x11vnc xvfb \
    curl libx11-6 libxkbfile1 libsecret-1-0 \
    dbus-x11 xterm \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Code-Server installieren (ARM-Version)
RUN curl -fsSL https://github.com/coder/code-server/releases/download/v4.14.1/code-server-4.14.1-linux-arm64.tar.gz | tar -xz -C /usr/local && \
    mv /usr/local/code-server-4.14.1-linux-arm64 /usr/local/code-server && \
    ln -s /usr/local/code-server/bin/code-server /usr/bin/code-server

# VNC Passwort setzen (leer -> kein Passwort)
RUN mkdir -p ~/.vnc && echo "" > ~/.vnc/passwd

# Volume für User-Daten
VOLUME /home

# Startup-Skript erstellen
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Port für Code-Server & VNC
EXPOSE 8080 5900

# Starten mit eigenem Skript
CMD ["/entrypoint.sh"]
