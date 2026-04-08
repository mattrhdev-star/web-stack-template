#!/bin/bash
# Install dependencies
npm install
# Bundle TypeScript into a single JS file in the public folder
npx esbuild src/index.ts --bundle --outfile=public/bundle.js