#!/bin/bash
source ./urlencode.sh
echo "Your scope is $scope"

echo "Processing added files"
for file in $a; do
  if [ -n "$(echo "$file" | grep -oP '(^|/)\.')" ]; then
    echo "- ignoring $file ..."
  else
    echo "- adding $file ..."
    enc="$(urlencode "$file")"
    echo -n "  "
    curl --fail-with-body -s -X PUT $url/$scope/$enc -H "x-mastory-api-key: $api_key" --upload-file "$file"
    echo
  fi
done

echo "Processing modified files"
for file in $m; do
  if [ -n "$(echo "$file" | grep -oP '(^|/)\.')" ]; then
    echo "- ignoring $file ..."
  else
    echo "- updating $file ..."
    enc="$(urlencode "$file")"
    echo -n "  "
    curl --fail-with-body -s -X PATCH $url/$scope/$enc -H "x-mastory-api-key: $api_key" --upload-file "$file"
    echo
  fi
done

echo "Processing deleted files"
for file in $d; do
  if [ -n "$(echo "$file" | grep -oP '(^|/)\.')" ]; then
    echo "- ignoring $file ..."
  else
    echo "- deleting $file ..."
    enc="$(urlencode "$file")"
    echo -n "  "
    curl --fail-with-body -s -X DELETE $url/$scope/$enc -H "x-mastory-api-key: $api_key"
    echo
  fi
done

echo "Processing renamed files"
for pair in $r; do
  old="${pair%>*}"
  new="${pair#*>}"
  echo "- renaming ${old} ---> ${new}"
  oldenc="$(urlencode "$old")"
  newenc="$(urlencode "$new")"
  echo -n "  "
  curl --fail-with-body -s -X POST $url/$scope -H "content-type: application/json" -H "x-mastory-api-key: $api_key" --data '{"op":"rename","old_name":"'"${oldenc}"'","new_name":"'"${newenc}"'"}'
  echo
done

echo "Processing copied files"
for file in $c; do
  echo "- $file was reported as copied from tj-actions/changed-files, but there is no handler implemented for this case."
  echo "Please report this issue to felix@mastory.io"
  exit 1
done