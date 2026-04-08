cosign verify-blob dist/bundle.js \
  --signature dist/bundle.js.sig \
  --certificate-identity "https://github.com/mattrhdev-star/web-stack-template/.github/workflows/ci.yml@refs/heads/main" \
  --certificate-oidc-issuer "https://token.actions.githubusercontent.com"