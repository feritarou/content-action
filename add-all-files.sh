#!/bin/bash
echo "Adding all files in the repository"
find . -type f -not -wholename './.git/**' -exec "${GITHUB_ACTION_PATH}/add-file.sh" '{}' \;
