#!/usr/bin/env bash
export alpineUrl="http://dl-cdn.alpinelinux.org/alpine/v3.6/releases/armhf/"
# get all the minirootfs Files

wget -O - -q $alpineUrl |
grep minirootfs |
tail -4 |
cut -d'>' -f 2 |
cut -d'<' -f 1 > filenames.log

while read -r line
do
    file="$line"
    echo "Downloading [$alpineUrl$file]"
    wget -q $alpineUrl$file
done < filenames.log

rm filenames.log
