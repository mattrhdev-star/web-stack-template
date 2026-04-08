#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status

echo "Installing dependencies..."
npm install

echo "Type checking..."
npx tsc --noEmit # This checks for errors without generating files

echo "Bundling for browser..."
# This combines everything into one file the browser can read
npx esbuild src/index.ts --bundle --minify --outfile=public/bundle.js

echo "Build successful!"