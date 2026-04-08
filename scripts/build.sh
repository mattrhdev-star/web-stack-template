#!/bin/bash
set -e 

echo "--- 1. Environment Setup ---"
mkdir -p dist
mkdir -p public

echo "--- 2. Dependency Sync & Integrity Check ---"
# 'npm install' ensures we have the tools, but we add an audit gate
npm install
npm audit --audit-level=high

echo "--- 3. Static Analysis (Code Vulnerabilities) ---"
# Gate: If the TypeScript is broken or "unsafe", the build fails here.
npx tsc --noEmit

echo "--- 4. Supply Chain Scan (Trivy + VEX) ---"
# Gate: Scans for CVEs. Fails if CRITICAL/HIGH found (unless in VEX).
if command -v trivy &> /dev/null; then
    trivy fs . \
      --exit-code 1 \
      --severity HIGH,CRITICAL \
      --vex security/project.vex.json \
      --format table
else
    echo "Trivy not found, skipping deep scan. Falling back to npm audit."
fi

echo "--- 5. Compiling & Bundling ---"
if [ ! -f "src/index.ts" ]; then
    echo "Error: src/index.ts not found."
    exit 1
fi

# The bundle is ONLY created if all previous gates passed
npx esbuild src/index.ts --bundle --minify --outfile=dist/bundle.js

echo "--- 6. Integrity Verification ---"
if [ ! -f "dist/bundle.js" ]; then
    echo "Error: Bundle creation failed."
    exit 1
fi

echo "--- 7. Generating Security Artifacts ---"
# Generate the SBOM (The ingredients list)
npx @cyclonedx/cyclonedx-npm --output-format JSON --output-file dist/bom.json

# Copy VEX and static assets
[ -f "security/project.vex.json" ] && cp security/project.vex.json dist/
[ -f "public/index.html" ] && cp public/index.html dist/
[ -f "public/style.css" ] && cp public/style.css dist/

echo "--- ✅ Build Process Securely Complete ---"

