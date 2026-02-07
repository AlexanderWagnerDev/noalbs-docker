# NOALBS Docker

Docker container for NOALBS (nginx-obs-automatic-low-bitrate-switching) v2.16.1 based on Alpine Linux.

## Features

- Multi-stage build for minimal image size
- Statically compiled binary
- Based on custom Alpine image
- Automatic OBS scene switching on connection issues
- Support for NGINX RTMP, SRT and MediaMTX stats

## Quick Start

```bash
docker build -t noalbs-docker .
docker run -v $(pwd)/config.json:/app/config.json \
           -v $(pwd)/.env:/app/.env \
           noalbs-docker
```

Or with Docker Compose:

```yaml
services:
  noalbs:
    build: .
    volumes:
      - ./config.json:/app/config.json
      - ./.env:/app/.env
    restart: unless-stopped
```

## Configuration

1. Adjust `.env` with your credentials
2. Configure `config.json` for your streaming scenes
3. Start the container

Configuration details: [NOALBS Documentation](https://github.com/NOALBS/nginx-obs-automatic-low-bitrate-switching)

## What is NOALBS?

NOALBS monitors your RTMP/SRT stream bitrate and automatically switches between OBS scenes:
- **Live**: Good connection
- **Low Bitrate**: Weak connection
- **Offline/BRB**: No connection

Perfect for IRL streaming with mobile internet connections.

## Build Details

- Base Image: `alexanderwagnerdev/alpine:builder` & `alexanderwagnerdev/alpine:latest`
- NOALBS Version: v2.16.1
- Rust/Cargo build with static linking

## License

MIT License

---

# NOALBS Docker (Deutsch)

Docker-Container für NOALBS (nginx-obs-automatic-low-bitrate-switching) v2.16.1 auf Basis von Alpine Linux.

## Features

- Multi-Stage Build für minimale Image-Größe
- Statisch kompiliertes Binary
- Basiert auf custom Alpine-Image
- Automatische Szenenwechsel in OBS bei Verbindungsproblemen
- Support für NGINX RTMP, SRT und MediaMTX Stats

## Schnellstart

```bash
docker build -t noalbs-docker .
docker run -v $(pwd)/config.json:/app/config.json \
           -v $(pwd)/.env:/app/.env \
           noalbs-docker
```

Oder mit Docker Compose:

```yaml
services:
  noalbs:
    build: .
    volumes:
      - ./config.json:/app/config.json
      - ./.env:/app/.env
    restart: unless-stopped
```

## Konfiguration

1. `.env` mit deinen Credentials anpassen
2. `config.json` für deine Streaming-Szenen konfigurieren
3. Container starten

Details zur Konfiguration: [NOALBS Dokumentation](https://github.com/NOALBS/nginx-obs-automatic-low-bitrate-switching)

## Was ist NOALBS?

NOALBS überwacht die Bitrate deines RTMP/SRT-Streams und wechselt automatisch zwischen OBS-Szenen:
- **Live**: Gute Verbindung
- **Low Bitrate**: Schwache Verbindung
- **Offline/BRB**: Keine Verbindung

Ideal für IRL-Streaming mit mobiler Internetverbindung.

## Build-Details

- Base Image: `alexanderwagnerdev/alpine:builder` & `alexanderwagnerdev/alpine:latest`
- NOALBS Version: v2.16.1
- Rust/Cargo Build mit statischem Linking

## Lizenz

MIT License
