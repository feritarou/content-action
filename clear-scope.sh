#!/bin/bash
source "${GITHUB_ACTION_PATH}/urlencode.sh"
echo "Clearing content scope $scope"
curl --fail-with-body -s -X DELETE $url/$scope -H "x-mastory-api-key: $api_key"
echo