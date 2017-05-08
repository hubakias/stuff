#!/bin/bash

# Version 0.01
# GPL v2

# Should run via cron.
# rtorrent should be configured to send notifications on start/stop/done ...
# If the above is not possible for some cases, incron could be used.

if ! [ "$(which find)" ] || ! [ "$(which curl)" ] || ! [ "$(which rtorrent)" ]; then
    echo "This script depends on the coreutils, findutils, curl, rtorrent,"
    echo "grep and sed. Please make sure they all exist on the system." 
fi

# Place you showRSS user_id here (it will be a number - not the username)
# Too bad showrss does not use https and authentication. Everyone in your
# "connection path" can view your viewing habits.
show_rss_user_id="000000"

tmp_file="/tmp/$(date +%s%N | sha256sum | cut -d ' ' -f1).tmp"


# Some sanity check about show rss user id
if [[ -z "$show_rss_user_id" ]] || ! [[ "$show_rss_user_id" =~ ^[0-9]+$ ]] ; then
    echo "Show RSS user does not seem to be set."
    exit 1
fi

# Check that .rtorrent.rc exists in order to get the necessary info
if [ ! -f ~/.rtorrent.rc ]; then
    echo " ~/.rtorrent.rc is missing"
    exit 1
fi

# Get the load_start directory - tested on 0.9.2 rtorrent.rc - be careful!!!
ls_rtorrent_dir="$(grep load_start ~/.rtorrent.rc | sed "s/.*=// ; s/\*.*$//")"

if [ -z "$ls_rtorrent_dir" ] ; then
    echo "A watch dir does not seem to exist."
    exit 1
fi

# Check if the dir has an absolute path. If not add user's homedir to the path.
if [[ $ls_rtorrent_dir == .* ]]; then
    ls_rtorrent_dir="$HOME/$ls_rtorrent_dir"
fi

# expand tilde if it exists
eval ls_rtorrent_dir="$ls_rtorrent_dir"

# Get the rss feed, partially parse it and add it to the temp file
curl -s http://showrss.info/rss.php?user_id="$show_rss_user_id" | sed "s:\(<[a-zA-Z]*>\)\(<[a-zA-Z]*>\):\n\2:g ; s:\(</[a-zA-Z]*>\):&\n:g ;" | egrep "^<link>mag" | sed "s/\(<.[a-zA-Z]*>\)//g ; s/\&amp\;/\&/g" > "$tmp_file"

# The below will create a file for every torrent in the rss - yes, it does not check if it already exists but this shouldn't be an issue
# Should try to think of a solution though.
cat "$tmp_file" | while read line; do
    #echo "d10:magnet-uri${#line}:${line}e" > $ls_rtorrent_dir$(date +%s%N |sha256sum | cut -d ' ' -f1).torrent
    echo "d10:magnet-uri${#line}:${line}e" > "$ls_rtorrent_dir"$(echo "$line" | sed "s/magnet:?xt=urn:btih:// ; s/\&dn=.*//").torrent
done

# Cleanup
rm -f "$tmp_file"

