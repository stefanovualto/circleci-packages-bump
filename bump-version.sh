#!/bin/bash

PACKAGE_GIT_VERSION=$(curl -s https://raw.githubusercontent.com/[user]/[repo]/master/package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g')

  PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g')

if [ "$PACKAGE_GIT_VERSION" == "$PACKAGE_VERSION" ]
then
git config --global user.email "vuplay@vualto.com" && git config --global user.name "vuplay" && git config --global push.default simple

npm version patch -m "updated patch version [ci skip]" && git push
fi