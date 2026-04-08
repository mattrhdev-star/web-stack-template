#!/bin/bash
set -e

# Setup clean directories
rm -rf dist public/bundle.js
mkdir -p dist

echo "--- 1. Build & Bundle ---"
npm ci
npx tsc --noEmit
npx esbuild src/index.ts --bundle --minify --outfile=dist/bundle.js

# Copy static assets to dist for the final site
cp public/index.html dist/
cp public/style.css dist/

echo "--- 2. Generate Security Artifacts ---"
# Generate SBOM
npx @cyclonedx/cyclonedx-npm --output-format JSON --output-file dist/bom.json

# Copy VEX for transparency
if [ -f "security/project.vex.json" ]; then
    cp security/project.vex.json dist/
fi

echo "Build artifacts ready in ./dist"