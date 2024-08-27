#!/bin/bash
function urlencode() {
  printf %s "$1" | jq -sRr @uri | sed -E -e 's|%2F|/|g'
}

if [ -n "$1" ]; then
  echo -n $(urlencode "$1")
fi