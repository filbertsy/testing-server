#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$0")"

JAVA="${JAVA:-java}"
MC_VERSION="${MC_VERSION:-1.21.8}"
XMS="${XMS:-2G}"
XMX="${XMX:-4G}"
PAPER_JAR="${PAPER_JAR:-paper.jar}"

if ! command -v "$JAVA" >/dev/null 2>&1; then
  echo "ERROR: Java was not found. Install Java 21 and ensure it is on PATH." >&2
  exit 1
fi

JAVA_MAJOR="$("$JAVA" -version 2>&1 | awk -F '"' '/version/ {split($2,a,"."); if (a[1]=="1") print a[2]; else print a[1]; exit}')"
if [[ -z "$JAVA_MAJOR" || "$JAVA_MAJOR" -lt 21 ]]; then
  echo "ERROR: This template requires Java 21 or newer. Detected: ${JAVA_MAJOR:-unknown}" >&2
  exit 1
fi

if [[ ! -f eula.txt ]] || ! grep -qE '^eula=true$' eula.txt; then
  echo "The Minecraft EULA has not been accepted."
  echo "Read https://www.minecraft.net/eula and set eula=true in eula.txt only if you agree."
  exit 1
fi

if [[ ! -f "$PAPER_JAR" ]]; then
  echo "Looking up the latest Paper build for Minecraft $MC_VERSION..."
  META="$(curl --fail --silent --show-error "https://api.papermc.io/v2/projects/paper/versions/$MC_VERSION/builds")"
  BUILD="$(printf '%s' "$META" | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d["builds"][-1]["build"])')"
  DOWNLOAD_NAME="$(printf '%s' "$META" | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d["builds"][-1]["downloads"]["application"]["name"])')"
  URL="https://api.papermc.io/v2/projects/paper/versions/$MC_VERSION/builds/$BUILD/downloads/$DOWNLOAD_NAME"
  echo "Downloading Paper build $BUILD..."
  curl --fail --location --retry 3 --output "$PAPER_JAR.tmp" "$URL"
  mv "$PAPER_JAR.tmp" "$PAPER_JAR"
fi

mkdir -p plugins config
exec "$JAVA" -Xms"$XMS" -Xmx"$XMX" -jar "$PAPER_JAR" --nogui
