#!/usr/bin/env bash

# Set up the environment.

PLUGIN_DIR="$HOME/Library/Application Support/Developer/Shared/Xcode/Plug-ins"
STARCONSOLELINK_PATH="$PLUGIN_DIR/StarConsoleLink.xcplugin"

# Check path, Remove if exist

if [ -d "$PLUGIN_DIR" ]; then
    if [ -d "$STARCONSOLELINK_PATH" ]; then
        echo ""
        echo "Remove $STARCONSOLELINK_PATH"
        rm -rf "$STARCONSOLELINK_PATH"
    fi
fi

echo ""
echo "Downloading StarConsoleLink..."

# Prepare
mkdir -p /var/tmp/StarConsoleLink.tmp && cd /var/tmp/StarConsoleLink.tmp

echo ""
# Clone from git
git clone https://github.com/iStarEternal/StarConsoleLink.git --depth 1 /var/tmp/StarConsoleLink.tmp > /dev/null

echo ""
echo "Installing StarConsoleLink..."

# Then build
xcodebuild clean > /dev/null
xcodebuild > /dev/null

# Remove tmp files
cd ~
rm -rf /var/tmp/StarConsoleLink.tmp

# Done
echo ""
if [ -d "$PLUGIN_DIR"]; then
    if [ -d "$STARCONSOLELINK_PATH" ]; then
        echo "StarConsoleLink successfully installed! 🍻 Please restart your Xcode."
    else
        echo "StarConsoleLink installation failed! 🍻 I'm sorry 😭😭😭."
    fi
fi
echo ""