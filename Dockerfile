# Basis-Image mit Node.js (für code-server)
FROM codercom/code-server:latest

# Erstelle ein Arbeitsverzeichnis
WORKDIR /app

# Installiere Python, pip und venv (für virtuelle Umgebungen)
USER root
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv && \
    # Erstelle ein virtuelles Python-Umfeld
    python3 -m venv /venv && \
    # Installiere die benötigten Python-Pakete in das virtuelle Umfeld
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install jupyterlab numpy pandas matplotlib && \
    # Bereinige Cache, um das Image kleiner zu machen
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Kopiere lokale Dateien ins Image
COPY . /app

# Exponiere die Ports für code-server und JupyterLab
EXPOSE 8080 8888

# Benutze tini als Init-Prozess, um beide Prozesse zu starten
RUN apt-get update && apt-get install -y tini

# Starte code-server und JupyterLab gleichzeitig, benutze das virtuelle Python-Umfeld
CMD ["/usr/bin/tini", "--", "sh", "-c", "code-server --bind-addr 0.0.0.0:8080 --auth none . & /venv/bin/jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root"]

