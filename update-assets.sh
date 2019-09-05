#!/bin/bash

if ! rpm -q yarn; then
  echo "Yarn is required to run this script."
  echo "See https://yarnpkg.com/lang/en/docs/install/#centos-stable"
  exit 1
fi

pushd ../mig-ui
yarn build
popd

rm -rf dist node_modules public/favicon.ico public/index.ejs deploy/main.js scripts/entrypoint.sh
cp -r ../mig-ui/dist ./
cp -r ../mig-ui/node_modules ./
cp ../mig-ui/public/favicon.ico ./public 
cp ../mig-ui/public/index.ejs ./public
cp ../mig-ui/deploy/main.js ./deploy
cp ../mig-ui/scripts/entrypoint.sh ./scripts
