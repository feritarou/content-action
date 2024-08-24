#!/bin/bash

set -e

scope="$1"
echo "Your scope is $1"'!'

echo "Processing added files"
for file in ${ADDED_FILES}; do
  echo "- $file ..."
done

echo "Processing copied files"
for file in ${COPIED_FILES}; do
  echo "- $file ..."
done

echo "Processing modified files"
for file in ${MODIFIED_FILES}; do
  echo "- $file ..."
done

echo "Processing deleted files"
for file in ${DELETED_FILES}; do
  echo "- $file ..."
done

echo "Processing renamed files"
for file in ${RENAMED_FILES}; do
  echo "- $file ..."
done