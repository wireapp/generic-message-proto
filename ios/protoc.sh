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

# Check if protoc is in PATH
if command -v protoc >/dev/null 2>&1; then
    PROTOC_CMD=$(command -v protoc)
else
    # Fallback to a specific path
    if [ -x /opt/homebrew/bin/protoc ]; then
        PROTOC_CMD="/opt/homebrew/bin/protoc"
    else
        echo "Error: protoc not found in PATH or /opt/homebrew/bin/protoc"
        exit 1
    fi
fi

echo "Using protoc at: $PROTOC_CMD"

# Example usage:
"$PROTOC_CMD" "$@"
