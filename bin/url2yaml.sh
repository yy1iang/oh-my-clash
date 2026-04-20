#!/bin/sh

# Author: Yanyang Liang <yyliang1212@gmail.com>
# Date  : Apr 20, 2026

# Initialize parameters
LINK=""
CONFIG=""
TARGET=""
OUTPUT=""

# Help menu
usage() {
    echo
    echo "$0 [-i <link>] [-t <target>] [options]"
    echo
    echo "  -i  (Required) Subscription link."
    echo "  -t  (Required) Target subscription type."
    echo "  -c  External configuration file path or URL."
    echo "  -o  Output file path."
    echo
    exit 0
}

# Parse arguments
while getopts "i:c:t:o:h" opt; do
    case $opt in
        i) LINK="$OPTARG" ;;
        c) CONFIG="$OPTARG" ;;
        t) TARGET="$OPTARG" ;;
        o) OUTPUT="$OPTARG" ;;
        h) usage ;;
        *) usage ;;
    esac
done

# Verify inputs
if [ $# -eq 0 ]; then
    usage
fi

if [ -z "$LINK" ]; then
    echo "Error: Subscription link not specified."
    usage
fi

if [ -z "$TARGET" ]; then
    echo "Error: Target format not specified."
    usage
fi

# Build functions for URL encoding/decoding
url_decode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

url_encode() {
    local string="$1"
    local strlen=${#string}
    local encoded=""
    local pos=0
    while [ $pos -lt $strlen ]; do
        local char=${string:$pos:1}
        case "$char" in
            [a-zA-Z0-9-._~])
                encoded="${encoded}${char}"
                ;;
            *)
                encoded="${encoded}$(printf '%%%02X' "'$char")"
                ;;
        esac
        pos=$((pos + 1))
    done
    echo "$encoded"
}


# Start conversion
echo "[INFO] Target format : $TARGET"
echo "[INFO] Output file   : $OUTPUT"

# Extract source URL
# if link has `url=` param, decode and use it,
# otherwise use as-is.
RAW_PARAM=$(echo "$LINK" | grep -oE 'url=[^&]+' | head -1 | cut -d= -f2-)
if [ -n "$RAW_PARAM" ]; then
    SOURCE=$(url_decode "$RAW_PARAM")
    echo "[INFO] Input type    : converter URL (extracted source)"
else
    SOURCE="$LINK"
    echo "[INFO] Input type    : raw source URL"
fi
echo "[INFO] Source URL    : $SOURCE"

ENCODED=$(url_encode "$SOURCE")
echo "[INFO] Encoded URL   : $ENCODED"

# Build query URL string
QUERY="target=${TARGET}&emoji=true&udp=true&new_name=true&url=${ENCODED}"
if [ -n "$CONFIG" ]; then
    case "$CONFIG" in
        http://*|https://*)
            CONFIG_VALUE=$(url_encode "$CONFIG")
            echo "[INFO] Config        : $CONFIG (URL)"
            ;;
        *)
            CONFIG_VALUE="$CONFIG"
            echo "[INFO] Config        : $CONFIG (file)"
            ;;
    esac
    QUERY="${QUERY}&config=${CONFIG_VALUE}"
else
    echo "[INFO] Config        : (default)"
fi

REQUEST_URL="http://127.0.0.1:25500/sub?${QUERY}"
echo "[INFO] Request URL   : $REQUEST_URL"

if [ -z "$OUTPUT" ]; then
    exit 0
fi

echo "[INFO] Fetching..."
HTTP_CODE=$(curl -s -w "%{http_code}" --noproxy "*" "$REQUEST_URL" -o "$OUTPUT")
echo "[INFO] HTTP status   : $HTTP_CODE"

if [ "$HTTP_CODE" = "200" ] && [ -s "$OUTPUT" ]; then
    SIZE=$(wc -c < "$OUTPUT")
    echo "[INFO] Output size   : ${SIZE} bytes"
    echo "[INFO] Done. Saved to $OUTPUT"
else
    echo "[ERRO] ERROR: conversion failed"
    echo "[ERRO] HTTP status   : $HTTP_CODE"
    exit 1
fi
