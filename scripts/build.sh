#!/bin/bash
set -e  # Exit on any error

echo "--- 1. Preparation ---"
mkdir -p dist
mkdir -p public

echo "--- 2. Install ---"
# We use install here to ensure the lockfile is bootstrapped
npm install

echo "--- 3. Build & Bundle ---"
# Check if src/index.ts exists
if [ ! -f "src/index.ts" ]; then
    echo "Error: src/index.ts not found!"
    exit 1
fi

# Run esbuild and verify it creates the file
npx esbuild src/index.ts --bundle --minify --outfile=dist/bundle.js

echo "--- 4. Verify Bundle Existence ---"
if [ -f "dist/bundle.js" ]; then
    echo "Success: dist/bundle.js created."
else
    echo "Error: dist/bundle.js was NOT created."
    exit 1
fi

# Copy assets
cp public/index.html dist/ 2>/dev/null || echo "No index.html found"
cp public/style.css dist/ 2>/dev/null || echo "No style.css found"

echo "--- 5. Generate SBOM ---"
npx @cyclonedx/cyclonedx-npm --output-format JSON --output-file dist/bom.json


# Copy VEX for transparency
if [ -f "security/project.vex.json" ]; then
    cp security/project.vex.json dist/
fi

echo "Build artifacts ready in ./dist"