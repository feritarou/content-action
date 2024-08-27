#!/bin/bash
source ./urlencode.sh
rel="$1"
file="${rel:2}"
if [ -n "$(echo "$file" | grep -oP '(^|/)\.')" ]; then
  echo "- ignoring $file ..."
else
  echo "- adding $file ..."
  echo -n "  "
  enc="$(urlencode "$file")"
  # curl --fail-with-body -s -X PUT $url/$scope/$enc -H "x-mastory-api-key: $api_key" --upload-file "$file"
  echo "URL-encoded: $enc"
fi