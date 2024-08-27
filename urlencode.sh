#!/bin/bash
function urlencode() {
  printf %s "$1" | jq -sRr @uri | sed -E -e 's|%2F|/|g'
}