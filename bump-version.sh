#!/bin/bash

# Description: bump version only if the previous master version was the same (not manually modified)
# Requirements: The local package.json must have an upper property "url" setted with the git url of the project
git config --global user.email "vuplay@vualto.com" && git config --global user.name "vuplay" && git config --global push.default simple

git fetch
git checkout HEAD~1

PREVIOUS_PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g')

echo "PREVIOUS_PACKAGE_VERSION=${PREVIOUS_PACKAGE_VERSION}" 

git checkout master

  PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g')

  echo "PACKAGE_VERSION=${PACKAGE_VERSION}" 

  BUMPED_PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | awk -F '.' '{ print $1,$2,$3+1 }' \
  | sed 's/^ //' \
  | sed 's/ /./g')

  echo "BUMPED_PACKAGE_VERSION=${BUMPED_PACKAGE_VERSION}" 

if [ "$PREVIOUS_PACKAGE_VERSION" == "$PACKAGE_VERSION" ]
then
    npm version patch -m "CircleCi has bumped the patch version to $BUMPED_PACKAGE_VERSION [ci skip]" 
    echo "Version bumped from the old one"
    TAG_VERSION=BUMPED_PACKAGE_VERSION
elif [ "$PREVIOUS_PACKAGE_VERSION" == "" ]
then
    npm version patch -m "CircleCi has bumped the patch version to $BUMPED_PACKAGE_VERSION [ci skip]"
    echo "Version bumped wasn't able to find the previous one"
    TAG_VERSION=BUMPED_PACKAGE_VERSION
else
    git commit --allow-empty -m "CircleCi has released a specific version $PACKAGE_VERSION [ci skip]"
    echo "Version wasn't bumped due to a modification of the major or minor version"
    TAG_VERSION=PACKAGE_VERSION
fi
git tag -a v$TAG_VERSION -m "CircleCi has taged this version $TAG_VERSION"
git push

echo "V3"