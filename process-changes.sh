#!/bin/bash
source "${GITHUB_ACTION_PATH}/urlencode.sh"
echo "Your scope is $scope"

echo "Processing added files"
IFS='<' read -ra files <<< "$a"
for file in "${files[@]}"
do
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
IFS='<' read -ra files <<< "$m"
for file in "${files[@]}"
do
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
IFS='<' read -ra files <<< "$d"
for file in "${files[@]}"
do
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
IFS='<' read -ra pairs <<< "$r"
for pair in "${pairs[@]}"
do
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
IFS='<' read -ra files <<< "$c"
for file in "${files[@]}"
do
  echo "- $file was reported as copied from tj-actions/changed-files, but there is no handler implemented for this case."
  echo "Please report this issue to felix@mastory.io"
  exit 1
done