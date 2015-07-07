#!/bin/bash

./tracker.sh start

ctorrent -t -u "http://Wassail.local:6969/announce" -s foo.torrent "$1"

ctorrent foo.torrent

./tracker.sh stop

rm foo.torrent
