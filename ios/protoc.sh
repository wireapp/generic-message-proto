#!/bin/bash
set -Eeuo pipefail

#
# Wire
# Copyright (C) 2025 Wire Swiss GmbH
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.
#

# By having this script in the Swift package, we can run protoc without
# passing -skipPackagePluginValidation to xcodebuild.

PROTOC_FALLBACK_PATH="/opt/homebrew/bin/protoc"
PROTOC_DOWNLOAD_URL="https://github.com/protocolbuffers/protobuf/releases/download/v31.1/protoc-31.1-osx-universal_binary.zip"
PROTOC_INSTALL_DIR="/usr/local/protoc-31.1"
TMP_DIR=""
TMP_DIR=""

# Delete temporary directory
cleanup() {
    if [ -n "$TMP_DIR" ] && [ -d "$TMP_DIR" ]; then
        echo "Cleaning up temporary files..."
        rm -rf "$TMP_DIR"
    fi
}

download_protoc() {
    echo "Downloading protoc from $PROTOC_DOWNLOAD_URL..."
    TMP_DIR=$(mktemp -d)
    curl -sL "$PROTOC_DOWNLOAD_URL" -o "$TMP_DIR/protoc.zip" || { echo "Download failed"; exit 1; }
    unzip -q "$TMP_DIR/protoc.zip" -d "$TMP_DIR/protoc"
    PROTOC_CMD="$TMP_DIR/protoc/bin/protoc"
}

# Logic to find or install protoc
if command -v protoc >/dev/null 2>&1; then
    PROTOC_CMD=$(command -v protoc)
elif [ -x "$PROTOC_FALLBACK_PATH" ]; then
    PROTOC_CMD="$PROTOC_FALLBACK_PATH"
else
    echo "protoc not found, proceeding to download and install."
    download_protoc
fi

echo "Using protoc at: $PROTOC_CMD"

# Run protoc with all arguments passed
"$PROTOC_CMD" "$@"
