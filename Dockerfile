# syntax=docker/dockerfile:1.26@sha256:ecfaec9ed6d810b56388c508f4121597bfbba70d41a6dfeee4d8cad5f295fc32
# =============================================================================
# Garage — Garage S3 object store + garage-webui admin panel, one container
#
# Both upstream projects publish `scratch`-based images (a single static
# binary each, no shared libs) — pulled in via multi-stage COPY --from, no
# rebuild-from-source needed. s6-overlay supervises both processes.
#
# GitHub:  https://github.com/junkerderprovinz/garage
# Image:   ghcr.io/junkerderprovinz/garage
# License: AGPL-3.0-only
# =============================================================================

ARG GARAGE_VERSION=v2.3.0@sha256:866bd13ed2038ba7e7190e840482bc27234c4afaf77be8cfa439ae088c1e4690
ARG WEBUI_VERSION=latest@sha256:17c793551873155065bf9a022dabcde874de808a1f26e648d4b82e168806439c
ARG S6_OVERLAY_VERSION=3.2.0.2

# -----------------------------------------------------------------------------
# Stage 1 — the official Garage binary (Deuxfleurs, Rust, scratch-based)
# -----------------------------------------------------------------------------
ARG GARAGE_VERSION
FROM dxflrs/garage:${GARAGE_VERSION} AS garage

# -----------------------------------------------------------------------------
# Stage 2 — the official garage-webui binary (khairul169, Go, scratch-based)
# -----------------------------------------------------------------------------
ARG WEBUI_VERSION
FROM khairul169/garage-webui:${WEBUI_VERSION} AS webui

# -----------------------------------------------------------------------------
# Stage 3 — final image
# -----------------------------------------------------------------------------
FROM debian:bookworm-slim@sha256:88200866dfff7ea7f5cbcb6ec7c8a701889efe6fe859fe64d6990e4b07ea4171

ARG S6_OVERLAY_VERSION
ARG TARGETARCH
ARG GARAGE_VERSION

LABEL org.opencontainers.image.title="Garage" \
      org.opencontainers.image.description="Garage S3 object store + web admin UI, plug-and-play for Unraid" \
      org.opencontainers.image.source="https://github.com/junkerderprovinz/garage" \
      org.opencontainers.image.licenses="AGPL-3.0-only" \
      org.opencontainers.image.version="${GARAGE_VERSION}" \
      org.opencontainers.image.vendor="junkerderprovinz" \
      maintainer="junkerderprovinz"

# hadolint ignore=DL3002
USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# - gosu:        minimal setuid helper for the s6 service scripts
# - openssl:     generate rpc_secret / admin_token when not supplied
# - ca-certificates, curl: health checks
# - tzdata:      TZ env var support
# - xz-utils:    decompress s6-overlay .tar.xz archives
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gosu \
        openssl \
        ca-certificates \
        curl \
        tzdata \
        xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Install s6-overlay v3 (init system + process supervisor).
RUN case "${TARGETARCH}" in \
        amd64)  S6_ARCH="x86_64"   ;; \
        arm64)  S6_ARCH="aarch64"  ;; \
        arm)    S6_ARCH="arm"      ;; \
        *)      echo "Unsupported arch: ${TARGETARCH}" && exit 1 ;; \
    esac \
    && S6_BASE="https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}" \
    && curl -fsSL "${S6_BASE}/s6-overlay-noarch.tar.xz"     | tar -C / -Jxp \
    && curl -fsSL "${S6_BASE}/s6-overlay-${S6_ARCH}.tar.xz" | tar -C / -Jxp

# The two static binaries. garage-webui's image entrypoint is /bin/main;
# garage's is /garage.
COPY --from=garage /garage       /usr/local/bin/garage
COPY --from=webui  /bin/main     /usr/local/bin/garage-webui

RUN chmod +x /usr/local/bin/garage /usr/local/bin/garage-webui \
    && /usr/local/bin/garage --version \
    && mkdir -p /data /config

# Init-log banner: single source at .github/assets/banner-raw.txt (the shared
# Junker-der-Provinz banner; CR stripped so the log shows it cleanly). Printed
# by print-banner.sh from the garage-ready service, as the last log block.
COPY .github/assets/banner-raw.txt /usr/local/share/banner-raw.txt
RUN tr -d '\r' < /usr/local/share/banner-raw.txt > /usr/local/share/banner.txt

COPY rootfs/ /
RUN chmod +x /usr/local/bin/print-banner.sh \
    /etc/cont-init.d/10-config.sh \
    /etc/services.d/garage/run \
    /etc/services.d/garage-webui/run \
    /etc/services.d/garage-ready/run

# S3 API (3900), S3 website (3902), WebUI (3909). RPC (3901) and the admin
# API (3903) are internal-only (webui talks to it over localhost) and not
# published by the Unraid template.
EXPOSE 3900 3902 3909

VOLUME ["/data", "/config"]

ENTRYPOINT ["/init"]
