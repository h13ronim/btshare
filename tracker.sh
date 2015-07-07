#!/bin/bash

case "$1" in
  "start")
    opentracker &
    ;;
  "stop")
    pkill -f opentracker
    ;;
  "status")
    echo "Not implemented yer"
    exit 1
    ;;
  *)
    echo "You have failed to specify what to do correctly."
    exit 1
    ;;
esac
