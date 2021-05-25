#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

cd nx-externaldep-repro

if ! [ -d "node_modules" ]; then
  npm ci
fi

echo "Running build in nx root"
npx nx build >/dev/null

echo "Note the bundle size"
ls -l dist/apps/myapp/main.js
echo "Note how external deps are used"
grep 'require("dotenv")' dist/apps/myapp/main.js

cd apps/myapp
echo "Running build in app directory"
npx nx build >/dev/null

cd ../..
echo "Note how bundle is bigger"
ls -l dist/apps/myapp/main.js
echo "Note how require dotenv is not in the bundle"
grep 'require("dotenv")' dist/apps/myapp/main.js || echo "require dotenv is not in the bundle"
