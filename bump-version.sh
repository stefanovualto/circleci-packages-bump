#!/bin/bash

# Description: bump version only if the previous master version was the same (not manually modified)
# Requirements: The local package.json must have an upper property "url" setted with the git url of the project
git config --global user.email "vuplay@vualto.com" && git config --global user.name "vuplay" && git config --global push.default simple

git checkout HEAD~1 ../previous

URL=`cat package.json | grep url | head -1`

PREVIOUS_PACKAGE_VERSION=$(cat ../previous/package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g')

echo "PREVIOUS_PACKAGE_VERSION=${PREVIOUS_PACKAGE_VERSION}" 

  PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g')

  echo "PACKAGE_VERSION=${PACKAGE_VERSION}" 

if [ "$PREVIOUS_PACKAGE_VERSION" == "$PACKAGE_VERSION" ]
then
  npm version patch -m "updated patch version [ci skip]" && git push
  echo "Version bumped"
fi