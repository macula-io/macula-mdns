#!/usr/bin/env bash
set -e

# Quality validation script for macula_mdns
# Run this before publishing to hex.pm

cd "$(dirname "$0")/.."

echo "============================================"
echo "  Validating macula_mdns"
echo "============================================"
echo ""

# Version check
PACKAGE_VERSION=$(grep -oP '(?<={vsn, ")[^"]+' src/mdns.app.src)
echo "Version: $PACKAGE_VERSION"
echo ""

# Check that macula_envy is published first
echo "[0/5] Checking dependency: macula_envy..."
if ! rebar3 hex search macula_envy 2>/dev/null | grep -q "macula_envy"; then
    echo "WARNING: macula_envy not found on hex.pm"
    echo "Make sure to publish macula_envy first!"
    echo ""
fi

# Clean build
echo "[1/5] Cleaning previous build..."
rm -rf _build rebar.lock
echo "OK"
echo ""

# Get dependencies
echo "[2/5] Fetching dependencies..."
rebar3 get-deps
echo "OK"
echo ""

# Compile with warnings as errors
echo "[3/5] Compiling (warnings_as_errors)..."
rebar3 compile
echo "OK"
echo ""

# Build documentation
echo "[4/5] Building documentation..."
rebar3 ex_doc
echo "OK"
echo ""

# Verify hex package builds
echo "[5/5] Building hex package..."
rebar3 hex build
echo "OK"
echo ""

echo "============================================"
echo "  All validations passed!"
echo "  Ready to publish macula_mdns $PACKAGE_VERSION"
echo "============================================"
echo ""
echo "IMPORTANT: Publish macula_envy first if not already done!"
echo "To publish, run: ./scripts/publish-to-hex.sh"
