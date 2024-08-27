#!/bin/bash
echo "Reinitializing store based on a full repository examination."
echo "Your scope is $scope"

echo "Clearing content scope ..."
curl --fail-with-body -s -X DELETE $url/$scope -H "x-mastory-api-key: ${{ inputs.api_key }}"
echo

echo "Processing all files in the repository ..."
for file in $(find . -type f -not -wholename './.git/**'); do
  if [ -n "$(echo "${file:2}" | grep -oP '(^|/)\.')" ]; then
    echo "- ignoring ${file:2} ..."
  else
    echo "- adding ${file:2} ..."
    echo -n "  "
    curl --fail-with-body -s -X PUT $url/$scope/${file:2} -H "x-mastory-api-key: ${{ inputs.api_key }}" --upload-file "${file:2}"
    echo
  fi
done
