#!/usr/bin/env bash
alpineUrl="http://dl-2.alpinelinux.org/alpine/latest-stable/releases/armhf/"
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

rootfsfile=$(head -1 filenames.log)
signaturefile=$(tail -1 filenames.log)

OK=$(sha512sum -c $signaturefile | grep OK | wc -l)

   if [ $OK -eq 1 ]; then
       echo "File sucesfully validated!!!. [sha512 signature]"

       OldKey='Default'

       if [ -f signature.tar.xz.sha512 ]; then
          OldKey=$(sha512sum signature.tar.xz.sha512 | cut -d' ' -f 1)
       fi

       NewKey=$(sha512sum $signaturefile | cut -d' ' -f 1)
       
       echo old key: $OldKey
       echo new key: $NewKey

       if [ "$OldKey" != "$NewKey" ]; then
	echo "A new Alpine version detected $rootfsfile  [Alpine]"

	echo "Renaming to rootfs.tar.xz"
	cp $rootfsfile rootfs.tar.xz

	echo "Renaming Signature"
	cp $signaturefile signature.tar.xz.sha512
       fi
   fi
