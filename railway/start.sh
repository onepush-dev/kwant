#!/bin/sh
set -eu
DATA="${KWNT_DATA_DIR:-/data}"
mkdir -p "$DATA/.home"
chown -R kwnt:kwnt "$DATA" 2>/dev/null || true
export HOME="$DATA/.home"
export KWNT_PORT="${PORT:-${KWNT_PORT:-8080}}"
if [ -z "${KWNT_ALLOWED_ORIGINS:-}" ] && [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
  export KWNT_ALLOWED_ORIGINS="https://${RAILWAY_PUBLIC_DOMAIN}"
fi
if [ -z "${KWNT_API_TOKEN:-}" ]; then
  echo "kwnt-railway: KWNT_API_TOKEN is not set; kwnt will create its own token in $DATA/api-token." >&2
fi
if [ "$#" -eq 0 ]; then set -- kwnt serve; fi
exec setpriv --reuid=kwnt --regid=kwnt --init-groups -- "$@"
