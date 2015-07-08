#!/bin/bash

D_R=`cd \`dirname $0\` ; pwd -P`

# Create unique name for torrent file
TORRENT_FILE="$(date +"%s")-$(md5 -q -s "$1")"

# Path to torrent file
TORRENT_PATH=$D_R/tmp/$TORRENT_FILE.torrent

# Launch tracker
$D_R/bin/tracker.sh start

# Generate torrent file
ctorrent -t -u "http://$(hostname).local:6969/announce" -s $TORRENT_PATH "$1"

# Copy magnet link to clipboard
$D_R/bin/magneto.rb $TORRENT_PATH | pbcopy

# Seed torrent (ctrl-c to stop)
aria2c --bt-enable-lpd=true --bt-seed-unverified --seed-ratio 0 $TORRENT_PATH

# Stop tracker
$D_R/bin/tracker.sh stop

# Remove torrent file
rm $TORRENT_PATH
