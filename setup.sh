#!/bin/bash

# Erstelle Datenverzeichnis
mkdir -p data

# Starte Container
echo "Starte Container..."
if [ "docker-compose" = "docker-compose" ] || [ "docker-compose" = "podman-compose" ]; then
  docker-compose up -d
else
  # Bei "docker compose" oder "podman compose" (mit Leerzeichen)
  $CONTAINER_ENGINE compose up -d
fi

echo "Node-RED mit Deno sollte nun verfügbar sein unter: http://localhost:1880" # Prüfe, ob Docker oder Podman installiert ist
CONTAINER_ENGINE=""
if command -v docker >/dev/null 2>&1; then
  CONTAINER_ENGINE="docker"
  echo "Docker wird benutzt."
elif command -v podman >/dev/null 2>&1; then
  CONTAINER_ENGINE="podman"
  echo "Podman wird benutzt."
else
  echo "Weder Docker noch Podman wurden gefunden. Bitte installiere einen der beiden Container-Engines und versuche es erneut."
  exit 1
fi

# Prüfe ob Docker/Podman Compose installiert ist
if ! command -v docker-compose >/dev/null 2>&1; then
  echo "Docker Compose wurde nicht gefunden. Bitte installiere Docker compose und versuche es erneut."
  exit 1
fi

# Überprüfe, ob nvm installiert ist
if ! command -v nvm >/dev/null 2>&1 && [ ! -s "$HOME/.nvm/nvm.sh" ]; then
  echo "nvm wurde nicht gefunden. Möchtest du es installieren? [y/N]: "
  read -r install_nvm
  if [ "$install_nvm" = ^"Yy" ]; then
    echo "Installiere nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

    # Lade nvm für die aktuelle Shell
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  else
    echo "nvm wird nicht installiert."
  fi
fi

# Lade nvm falls es gerade installiert wurde
if [ -s "$HOME/.nvm/nvm.sh" ] && ! command -v nvm >/dev/null 2>&1; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Installiere und verwende die richtige Node.js-Version
if command -v nvm >/dev/null 2>&1; then
  if ! nvm ls 20.17.0 >/dev/null 2>&1; then
    read -p "Node.js 20.17.0 wurde nicht gefunden. Möchtest du es installieren? [y/N]: " install_node
    if [ "$install_node" = "j" ]; then
      echo "Installiere Node.js 20.17.0..."
      nvm install 20.17.0
      nvm use 20.17.0
    else
      echo "Node.js 20.17.0 wird nicht installiert."
    fi
  else
    nvm use 20.17.0
  fi
fi

# Überprüfe Node.js-Version
if command -v node >/dev/null 2>&1; then
  NODE_VERSION=$(node --version)
  echo "Aktuelle Node.js-Version: $NODE_VERSION"
fi

# Überprüfen, ob Deno installiert ist
if ! command -v deno >/dev/null 2>&1; then
  read -p "Deno wurde nicht gefunden. Möchtest du es installieren? [y/N]: " install_deno
  if [ "$install_deno" = "j" ]; then
    echo "Installiere Deno..."
    curl -fsSL https://deno.land/install.sh | sh

    # Pfad zu Deno in PATH hinzufügen
    export DENO_INSTALL="$HOME/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"

    # Füge Deno zum PATH in der Shell-Konfiguration hinzu
    if [ -f "$HOME/.zshrc" ]; then
      echo 'export DENO_INSTALL="$HOME/.deno"' >>"$HOME/.zshrc"
      echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >>"$HOME/.zshrc"
    fi

    if [ -f "$HOME/.bashrc" ]; then
      echo 'export DENO_INSTALL="$HOME/.deno"' >>"$HOME/.bashrc"
      echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >>"$HOME/.bashrc"
    fi
  else
    echo "Deno wird nicht installiert."
  fi
fi

# Stelle sicher, dass Deno im PATH ist
if [ -d "$HOME/.deno/bin" ] && ! command -v deno >/dev/null 2>&1; then
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

# Auf Deno Canary upgraden wenn Deno installiert ist
if command -v deno >/dev/null 2>&1; then
  echo "Möchtest du auf Deno Canary upgraden? [y/N]: "
  read -r upgrade_deno
  if [ "$upgrade_deno" = "j" ]; then
    echo "Upgrade auf Deno canary..."
    deno upgrade canary
  fi
fi

# Starte Docker Container
echo "Starte Docker-Container..."
if command -v docker-compose >/dev/null 2>&1; then
  docker-compose up -d
else
  docker compose up -d
fi

echo "Node-RED mit Deno sollte nun verfügbar sein unter: http://localhost:1880"
