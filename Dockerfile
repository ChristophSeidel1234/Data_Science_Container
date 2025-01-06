# Basis-Image mit Node.js (für code-server)
FROM codercom/code-server:latest

# Setze Root-Benutzer für Installationen
USER root

# Arbeitsverzeichnis erstellen
WORKDIR /app

# Installiere Python, pip, und virtuelle Umgebungen
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv tini && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Erstelle eine virtuelle Python-Umgebung
RUN python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip

# Kopiere lokale Dateien und requirements.txt ins Image
COPY requirements.txt /app/requirements.txt

# Installiere die Python-Abhängigkeiten in der virtuellen Umgebung
RUN /venv/bin/pip install -r /app/requirements.txt

# Setze die virtuelle Umgebung in den PATH
ENV PATH="/venv/bin:$PATH"

# Kopiere restliche Dateien ins Image
COPY . /app

# Ändere Besitz des Arbeitsverzeichnisses auf den Standardbenutzer "coder"
RUN chown -R coder:coder /app

# Setze den Benutzer zurück auf "coder" (Standardbenutzer des Images)
USER coder

# Exponiere die Ports für code-server und JupyterLab
EXPOSE 8080 8888

# Standardkommando: Starte code-server und JupyterLab mit tini
CMD ["/usr/bin/tini", "--", "sh", "-c", "code-server --bind-addr 0.0.0.0:8080 --auth none . & jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root"]
