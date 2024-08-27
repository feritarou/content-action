#!/bin/bash
echo "Your scope is $scope"

echo "Processing added files"
for file in $a; do
  if [ -n "$(echo "$file" | grep -oP '(^|/)\.')" ]; then
    echo "- ignoring $file ..."
  else
    echo "- adding $file ..."
    echo -n "  "
    curl --fail-with-body -s -X PUT $url/$scope/$file -H "x-mastory-api-key: ${{ inputs.api_key }}" --upload-file "$file"
    echo
  fi
done

echo "Processing modified files"
for file in $m; do
  if [ -n "$(echo "$file" | grep -oP '(^|/)\.')" ]; then
    echo "- ignoring $file ..."
  else
    echo "- updating $file ..."
    echo -n "  "
    curl --fail-with-body -s -X PATCH $url/$scope/$file -H "x-mastory-api-key: ${{ inputs.api_key }}" --upload-file "$file"
    echo
  fi
done

echo "Processing deleted files"
for file in $d; do
  if [ -n "$(echo "$file" | grep -oP '(^|/)\.')" ]; then
    echo "- ignoring $file ..."
  else
    echo "- deleting $file ..."
    echo -n "  "
    curl --fail-with-body -s -X DELETE $url/$scope/$file -H "x-mastory-api-key: ${{ inputs.api_key }}"
    echo
  fi
done

echo "Processing renamed files"
for pair in $r; do
  old="${pair%>*}"
  new="${pair#*>}"
  echo "- renaming ${old} ---> ${new}"
  echo -n "  "
  curl --fail-with-body -s -X POST $url/$scope -H "content-type: application/json" -H "x-mastory-api-key: ${{ inputs.api_key }}" --data '{"op":"rename","old_name":"'"${old}"'","new_name":"'"${new}"'"}'
  echo
done

echo "Processing copied files"
for file in $c; do
  echo "- $file was reported as copied from tj-actions/changed-files, but there is no handler implemented for this case."
  echo "Please report this issue to felix@mastory.io"
  exit 1
done