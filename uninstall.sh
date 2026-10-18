#!/usr/bin/env bash

set -e

DEST_DIR="${HOME}/.local/bin"
APP_DIR="${HOME}/.local/share/filesort_app"

echo "Uninstalling FileSort..."

if [[ -L "${DEST_DIR}/filesort" ]]; then
    rm -f "${DEST_DIR}/filesort"
fi

if [[ -d "$APP_DIR" ]]; then
    rm -rf "$APP_DIR"
fi

echo "Uninstallation complete."
echo "Note: Configuration and history in ~/.config/filesort and ~/.local/share/filesort are preserved."
