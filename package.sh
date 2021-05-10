#!/bin/bash -x

LOCAL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

rm -rf dist/server
mkdir -p dist/server
mkdir -p dist/server/logs

cp -R bin dist/server/bin
cp -R lib dist/server/lib
cp -R run dist/server
cp -R package.json dist/server/package.json
cp -R book.js dist/server/book.js
cp -R app.json dist/server/app.json

function exec_there() {
  DIR="$1"
  shift
  (cd "$DIR" || exit; "$@")
}

function get_file_store_access_token() {
  
  response=$(curl https://api.dropbox.com/oauth2/token \
    -d grant_type=refresh_token \
    -d refresh_token=YUYRuznisE4AAAAAAAAAARIGaMD8Kn0uBXRqWfwFNWRvkpQK77kh2y9rVY1iqjZL \
    -u 6xw91uvwdgmzy21:65v75d32ng9rtos)
  token=$(echo "$response" | cut -d' ' -f4 | cut -d'"' -f2)
  echo "$token"
}

function publish_trading_server() {
  
  exec_there "$LOCAL_DIR/dist" zip -vr "updateServer.zip" "server" -x "*.DS_Store"
  token=$(get_file_store_access_token)
  curl -X POST https://content.dropboxapi.com/2/files/upload \
    --header "Authorization: Bearer $token" \
    --header "Dropbox-API-Arg: {\"path\": \"/releases/updateServer.zip\",\"mode\": \"overwrite\",\"autorename\": false,\"mute\": false,\"strict_conflict\": false}" \
    --header "Content-Type: application/octet-stream" \
    --data-binary @"$LOCAL_DIR"/dist/updateServer.zip
  rm -rf "$LOCAL_DIR"/dist/updateServer.zip
}

publish_trading_server