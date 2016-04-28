#!/usr/bin/env bash

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
echo "StarConsoleLink successfully installed! 🍻 Please restart your Xcode."
echo ""