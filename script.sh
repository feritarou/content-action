#!/bin/bash

set -e

scope="$1"
echo "Your scope is $1"'!'

echo "Processing added files"
for file in ${ADDED_FILES}; do
  echo "- $file ..."
done