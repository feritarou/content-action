#!/bin/bash
source "${GITHUB_ACTION_PATH}/urlencode.sh"
echo "Reinitializing store based on a full repository examination."
echo "Your scope is $scope"

echo "Clearing content scope ..."
curl --fail-with-body -s -X DELETE $url/$scope -H "x-mastory-api-key: $api_key"
echo

echo "Processing all files in the repository ..."
find . -type f -not -wholename './.git/**' -exec "${GITHUB_ACTION_PATH}/handle-reinit.sh" '{}' \;