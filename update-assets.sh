#!/bin/bash
MIG_UI_URL=https://github.com/fusor/mig-ui
MIG_UI_DIR=mig-ui-build

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

if ! rpm --quiet -q yarn; then
  echo "Yarn is required to run this script."
  echo "See https://yarnpkg.com/lang/en/docs/install/#centos-stable"
  exit 1
fi

if [ "$#" -gt 2 ]; then
  echo "This script requires passing in zero, one, or two parameters."
  echo "If no parameters are passed in assets will be built from the corresponding mig-ui branch."
  echo "Otherwise the first should be the mig-ui branch to build mig-ui from."
  echo "You may also optionally pass in a specific hash to build from."
  exit 2
fi

if [ "$#" -gt 0 ]; then
  MIG_UI_BRANCH=$1
else
  MIG_UI_BRANCH=$(git symbolic-ref --short HEAD)
fi

if git clone -q $MIG_UI_URL -b $MIG_UI_BRANCH $MIG_UI_DIR; then
  echo "Cloned mig-ui $1 branch to build."
else
  echo "Failed to find branch $1"
  rm -rf $MIG_UI_DIR
  exit 3
fi

if [ "$#" -eq 2 ]; then
  pushd $MIG_UI_DIR
  if git reset -q --hard $2; then
    echo "Using hash $2 for build."
  else
    echo "Could not find hash $2."
    popd
    rm -rf $MIG_UI_DIR
    exit 4
  fi
fi 

pushd $MIG_UI_DIR
MIG_UI_BUILD_HASH=$(git rev-parse --short HEAD)
MIG_UI_BUILD_BRANCH=$(git symbolic-ref --short HEAD)
yarn
yarn build
popd

rm -rf dist node_modules public/favicon.ico public/index.ejs deploy/main.js scripts/entrypoint.sh
cp -r $MIG_UI_DIR/dist ./
cp -r $MIG_UI_DIR/node_modules ./
cp $MIG_UI_DIR/public/favicon.ico ./public 
cp $MIG_UI_DIR/public/index.ejs ./public
cp $MIG_UI_DIR/deploy/main.js ./deploy
cp $MIG_UI_DIR/scripts/entrypoint.sh ./scripts
rm -rf $MIG_UI_DIR

git add .
git commit -m "Update with assets built from $MIG_UI_BUILD_BRANCH-$MIG_UI_BUILD_HASH."

echo "Assets built from $MIG_UI_BUILD_BRANCH-$MIG_UI_BUILD_HASH."
echo "Build complete. Please check that it has done what you expect and push when ready."
