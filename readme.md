# Node-RED mit Deno 2.0 auf macOS

Diese Anleitung hilft dir, Node-RED mit Deno 2.0 auf macOS zu installieren und zu betreiben, als Container mit Docker oder Podman.

## Voraussetzungen

- macOS (funktioniert auf Intel- und Apple Silicon-Macs)
- Terminal-Zugang
- Docker Desktop für Mac oder Podman installiert

## Schnellstart

1. Lade das Setup-Skript herunter und mache es ausführbar:

```bash
chmod +x setup.sh
```

2. Führe das Skript aus:

```bash
./setup.sh
```

3. Folge den Anweisungen auf dem Bildschirm. Das Skript fragt nach Bestätigung, bevor es Software installiert.

## Was das Skript macht

Das Skript fragt nach Bestätigung und installiert bei Bedarf:

- nvm (Node Version Manager)
- Node.js v20.17.0
- Deno 2.0 Canary

Anschließend:

- Erkennt automatisch, ob Docker oder Podman installiert ist
- Richtet Podman im Docker-Kompatibilitätsmodus ein, falls nötig
- Erstellt ein Container-Image basierend auf Alpine Linux
- Konfiguriert Deno mit Node.js-Kompatibilitätsmodus
- Installiert Node-RED im Container
- Startet einen Container mit Port-Mapping auf 1880
- Speichert Daten in einem lokalen `./data`-Verzeichnis

## Nach der Installation

Node-RED ist unter http://localhost:1880 erreichbar.

## Fehlerbehebung

Falls Probleme auftreten:

### Bei Docker-Installation:
- Prüfe, ob Docker läuft: `docker ps`
- Schau die Container-Logs an: `docker logs node-red-deno_node-red-deno_1`

### Bei Podman-Installation:
- Prüfe, ob Podman läuft: `podman ps`
- Bei Podman im Docker-Kompatibilitätsmodus kannst du auch die Docker-Befehle verwenden

## Hinweis

Diese Integration von Node-RED mit Deno 2.0 ist experimentell. Da Deno 2.0 noch in der Entwicklung ist, kann es zu Kompatibilitätsproblemen kommen. Der Container hat einen Fallback auf Node.js, falls Deno Probleme verursacht.
