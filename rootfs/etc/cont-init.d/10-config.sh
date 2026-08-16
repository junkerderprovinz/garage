#!/command/with-contenv sh
# shellcheck shell=sh
# =============================================================================
# 10-config.sh — Container initialization script
# Runs once at container start (s6-overlay cont-init.d phase, stage 2).
#
# IMPORTANT: the shebang MUST use 'with-contenv' so the container's environment
# variables (set by 'docker run -e' / Unraid template) are available in this
# script. See matrix's own 10-config.sh for the full rationale.
#
# Responsibilities:
#   1. Generate /config/garage.toml on first boot only (idempotent — if it
#      already exists, it is left untouched, so RPC_SECRET/ADMIN_TOKEN never
#      change under a running install and existing S3 keys keep working).
#   2. Generate RPC_SECRET / ADMIN_TOKEN with openssl if the user did not
#      supply them, and persist the actually-used values into the rendered
#      config (not just env) so they survive a recreate that drops env vars.
#   3. Fix /data and /config ownership so the PUID:PGID the services run as
#      can write to them.
# =============================================================================

log_info()  { printf '\033[0;32m[init] INFO:  %s\033[0m\n'  "$*"; }
log_warn()  { printf '\033[0;33m[init] WARN:  %s\033[0m\n'  "$*"; }
log_error() { printf '\033[0;31m[init] ERROR: %s\033[0m\n'  "$*" >&2; }

PUID="${PUID:-99}"
PGID="${PGID:-100}"
DB_ENGINE="${DB_ENGINE:-sqlite}"
S3_REGION="${S3_REGION:-garage}"

mkdir -p /data /config

if [ ! -f /config/garage.toml ]; then
    log_info "First boot — generating /config/garage.toml"

    RPC_SECRET="${RPC_SECRET:-$(openssl rand -hex 32)}"
    ADMIN_TOKEN="${ADMIN_TOKEN:-$(openssl rand -base64 32)}"

    cat > /config/garage.toml <<EOF
metadata_dir = "/data/meta"
data_dir = "/data/blocks"
db_engine = "${DB_ENGINE}"

replication_factor = 1

rpc_bind_addr = "[::]:3901"
rpc_public_addr = "127.0.0.1:3901"
rpc_secret = "${RPC_SECRET}"

[s3_api]
s3_region = "${S3_REGION}"
api_bind_addr = "[::]:3900"
root_domain = ".s3.garage.local"

[s3_web]
bind_addr = "[::]:3902"
root_domain = ".web.garage.local"
index = "index.html"

[admin]
api_bind_addr = "127.0.0.1:3903"
admin_token = "${ADMIN_TOKEN}"
EOF
    log_info "garage.toml written (replication_factor=1, single-node)"
else
    log_info "garage.toml already exists — leaving it untouched"
fi

mkdir -p /data/meta /data/blocks
chown -R "${PUID}:${PGID}" /data /config 2>/dev/null || log_warn "chown failed — check PUID/PGID"

log_info "Init complete"
