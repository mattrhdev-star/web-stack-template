#!/bin/bash
set -e

echo "1. Installing Dependencies..."
npm ci # Use 'ci' for reproducible builds in pipelines

echo "2. Security Scan: Supply Chain (SCA)..."
# Fails if any 'high' or 'critical' vulnerabilities exist
npm audit --audit-level=high

echo "3. Generating SBOM (CycloneDX)..."
# Creates a bom.json in CycloneDX format
npx @cyclonedx/cyclonedx-npm --output-format JSON --output-file public/bom.json

echo "4. Static Analysis (SAST)..."
# Ensure types are valid before bundling
npx tsc --noEmit

echo "5. Bundling Application..."
npx esbuild src/index.ts --bundle --minify --outfile=public/bundle.js

echo "Build and Security checks passed!"