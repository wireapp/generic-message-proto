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

# Logic to find or install protoc
if command -v protoc >/dev/null 2>&1; then
    PROTOC_CMD=$(command -v protoc)
elif [ -x "$PROTOC_FALLBACK_PATH" ]; then
    PROTOC_CMD="$PROTOC_FALLBACK_PATH"
else
    echo "protoc not found"
    exit 1
fi

echo "Using protoc at: $PROTOC_CMD"

# Run protoc
"$PROTOC_CMD" --swift_opt=Visibility=Public --swift_opt=UseAccessLevelOnImports=true --swift_out=. *.proto
