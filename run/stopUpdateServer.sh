#!/bin/bash -x

PROCESS_PID=$(cat "/tmp/update-server-pid")
rm "/tmp/update-server-pid"
kill "$PROCESS_PID"

while kill -0 "$PROCESS_PID" >/dev/null 2>&1
do
  sleep 1
done
