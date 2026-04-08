#!/bin/bash
set -e # Exit immediately if any command fails

echo "--- 1. Environment Setup ---"
mkdir -p dist
mkdir -p public

echo "--- 2. Dependency Sync ---"
# We use install to ensure the lockfile is generated/synced
npm install

echo "--- 3. Compiling & Bundling ---"
# Ensure the source file actually exists
if [ ! -f "src/index.ts" ]; then
    echo "Error: src/index.ts not found. Check your file structure."
    exit 1
fi

# Run the bundler
npx esbuild src/index.ts --bundle --minify --outfile=dist/bundle.js

echo "--- 4. Integrity Check ---"
if [ -f "dist/bundle.js" ]; then
    echo "Success: dist/bundle.js is ready for signing."
else
    echo "Error: esbuild completed but dist/bundle.js is missing!"
    exit 1
fi

echo "--- 5. Security Artifacts ---"
npx @cyclonedx/cyclonedx-npm --output-format JSON --output-file dist/bom.json

# Copy static assets
cp public/index.html dist/ 2>/dev/null || echo "No index.html found"
cp public/style.css dist/ 2>/dev/null || echo "No style.css found"

echo "--- Build Process Complete ---"

echo "--- 5. Generate SBOM ---"
npx @cyclonedx/cyclonedx-npm --output-format JSON --output-file dist/bom.json


# Copy VEX for transparency
if [ -f "security/project.vex.json" ]; then
    cp security/project.vex.json dist/
fi

echo "Build artifacts ready in ./dist"