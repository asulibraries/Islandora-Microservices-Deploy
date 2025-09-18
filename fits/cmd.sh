#!/usr/bin/env bash

set -eou pipefail

TMP_DIR=$(mktemp -d)
INPUT_FILE="$TMP_DIR/input"

cleanup() {
  rm -rf "$TMP_DIR"
}

trap cleanup EXIT
cat > "$INPUT_FILE"

/app/fits.sh -i "$INPUT_FILE"