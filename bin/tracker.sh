#!/bin/bash

function tracket_status {
  pgrep opentracker > /dev/null
  return $?
}

case "$1" in
  "start")
    if tracket_status ; then
      echo "Tracker is already started"
    else
      opentracker &
    fi
    ;;
  "stop")
    pkill -f opentracker
    ;;
  "status")
    if tracket_status ; then
      echo "Tracker is started"
    else
      echo "Tracker is stopped"
    fi
    ;;
  *)
    echo "Available commands: start|stop|status"
    exit 1
    ;;
esac
