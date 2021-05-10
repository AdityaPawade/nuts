#!/bin/bash -x

LOCAL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR="$LOCAL_DIR/.."

cd "$ROOT_DIR/" || exit 

node bin/web.js > "$ROOT_DIR/logs/server.out" 2>&1 &
PROCESS_PID=$(echo $!)

cd - || exit;

echo "PID : $PROCESS_PID"
echo "$PROCESS_PID" > "/tmp/update-server-pid"