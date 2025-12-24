#!/usr/bin/env bash
set -e

# Hex.pm publish script for macula_mdns
# Fork of shortishly/mdns with rebar3 support

cd "$(dirname "$0")/.."

# Source secrets if available
[ -f "$HOME/.config/zshrc/01-secrets" ] && source "$HOME/.config/zshrc/01-secrets"

echo "============================================"
echo "  Publishing macula_mdns to hex.pm"
echo "============================================"
echo ""

# Check that macula_envy is published first
echo "Checking dependency: macula_envy..."
if ! rebar3 hex search macula_envy 2>/dev/null | grep -q "macula_envy"; then
    echo "ERROR: macula_envy must be published to hex.pm first!"
    echo "Run: cd ../macula-envy && ./scripts/publish-to-hex.sh"
    exit 1
fi
echo "OK - macula_envy is available on hex.pm"
echo ""

# Version check
PACKAGE_VERSION=$(grep -oP '(?<={vsn, ")[^"]+' src/macula_mdns.app.src)
echo "Version: $PACKAGE_VERSION"
echo ""

# Clean build
echo "Cleaning previous build..."
rm -rf _build rebar.lock
echo ""

# Get dependencies
echo "Fetching dependencies..."
rebar3 get-deps
echo ""

# Compile
echo "Compiling..."
rebar3 compile
echo ""

# Build docs (validates documentation)
echo "Building documentation..."
rebar3 ex_doc || echo "Documentation build had warnings"
echo ""

# Build hex package
echo "Building hex package..."
rebar3 hex build
echo ""

# Show package contents
echo "Package contents:"
rebar3 hex build --unpack | head -20 || true
echo ""

# Publish
echo "Publishing to hex.pm..."
rebar3 hex publish --yes
echo ""

echo "============================================"
echo "  Done! Published macula_mdns $PACKAGE_VERSION"
echo "============================================"
