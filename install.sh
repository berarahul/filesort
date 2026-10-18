#!/usr/bin/env bash

set -e

DEST_DIR="${HOME}/.local/bin"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing FileSort..."
mkdir -p "$DEST_DIR"

if [[ -L "${DEST_DIR}/filesort" || -e "${DEST_DIR}/filesort" ]]; then
    echo "Removing existing installation..."
    rm -f "${DEST_DIR}/filesort"
fi

# We can either copy the whole directory somewhere, or just symlink to the current repo.
# For a proper install, we should copy files to ~/.local/share/filesort_app
APP_DIR="${HOME}/.local/share/filesort_app"
mkdir -p "$APP_DIR"
cp -r "${SRC_DIR}/modules" "$APP_DIR/"
cp -r "${SRC_DIR}/config" "$APP_DIR/" 2>/dev/null || true
cp "${SRC_DIR}/filesort.sh" "$APP_DIR/"

ln -s "${APP_DIR}/filesort.sh" "${DEST_DIR}/filesort"

echo "Installation complete."
echo "Make sure ${DEST_DIR} is in your PATH."
