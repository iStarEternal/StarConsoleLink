#!/usr/bin/env bash

# Set up the environment.

PLUGIN_DIR="$HOME/Library/Application Support/Developer/Shared/Xcode/Plug-ins"
STARCONSOLELINK_PATH="$PLUGIN_DIR/StarConsoleLink.xcplugin"

# Remove

echo ""
echo "Remove StarConsoleLink..."

if [ -d "$PLUGIN_DIR" ]; then
    if [ -d "$STARCONSOLELINK_PATH" ]; then
        echo ""
        echo "Remove $STARCONSOLELINK_PATH"
        rm -rf "$STARCONSOLELINK_PATH"
    fi
fi

# Done
echo ""
echo "StarConsoleLink successfully uninstalled. Loved. Agoni.😢 Please restart your Xcode."
echo ""