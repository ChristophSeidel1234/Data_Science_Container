#!/bin/bash

# Neuen User anlegen, falls nicht vorhanden
if [ ! -d "/home/$USERNAME" ]; then
    useradd -m -s /bin/bash $USERNAME
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    mkdir -p /home/$USERNAME/.vnc
fi

# Arbeitsverzeichnis setzen
cd /home/$USERNAME

# Falls keine requirements.txt existiert, Standard erstellen
if [ ! -f "/home/$USERNAME/requirements.txt" ]; then
    echo "# Python Packages" > /home/$USERNAME/requirements.txt
fi

# Falls die Python-Module noch nicht installiert sind, nachinstallieren
pip3 install --user -r /home/$USERNAME/requirements.txt

# Code-Server starten
sudo -u $USERNAME code-server --bind-addr 0.0.0.0:8080 --auth none &

# VNC-Server für UI starten (z.B. mit XFCE)
export DISPLAY=:1
Xvfb :1 -screen 0 1280x720x16 &
xfce4-session & x11vnc -display :1 -nopw -forever &
wait
