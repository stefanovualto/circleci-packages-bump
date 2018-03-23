#!/bin/bash

BUMPED_PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | awk -F '.' '{ print $1,$2,$3+1 }' \
  | sed 's/^ //' \
  | sed 's/ /./g')

  echo "${PACKAGE_VERSION}"