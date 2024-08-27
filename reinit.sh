#!/bin/bash
source ./urlencode.sh
echo "Reinitializing store based on a full repository examination."
echo "Your scope is $scope"

echo "Clearing content scope ..."
curl --fail-with-body -s -X DELETE $url/$scope -H "x-mastory-api-key: $api_key"
echo

echo "Processing all files in the repository ..."
for rel in "$(find . -type f -not -wholename './.git/**')"; do
  file=${rel:2}
  if [ -n "$(echo "$file" | grep -oP '(^|/)\.')" ]; then
    echo "- ignoring $file ..."
  else
    echo "- adding $file ..."
    echo -n "  "
    enc="$(urlencode "$file")"
    curl --fail-with-body -s -X PUT $url/$scope/$enc -H "x-mastory-api-key: $api_key" --upload-file "$file"
    echo
  fi
done
