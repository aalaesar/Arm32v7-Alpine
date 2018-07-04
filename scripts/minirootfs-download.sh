#!/usr/bin/env bash
alpineUrl="http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/armhf/"

available_files() {
  # return the files present in the url, sorted by time (older to newer)
  local url="$1"
  while read myline; do
    myline_elmnts=($myline)
    # basically just converting the date format into timestamp for sorting
    myline_elmnts[0]="$(date -d "${myline_elmnts[0]/_/ }" +%s)"
    echo "${myline_elmnts[@]}"
  done < <(wget -O - -q $url | grep minirootfs| sed -r 's@^<a href="(.*)">.*</a>@\1@g'| awk '{print $2"_"$3" "$1}') | sort -t ' ' -k1n| awk '{print $2}'
}

#look over the 4 latest file but exclude Release candidates first
while read line
do
  if grep -q '\tar\.gz$' <<<"$line"; then
    rootfsfile="$line"
  elif grep -q '\tar\.gz\.sha512$' <<<"$line"; then
    signaturefile="$line"
    echo "Downloading [$alpineUrl$file]"
    wget -q $alpineUrl$file
  fi
done < <(available_files $alpineUrl | grep -Ev '_rc[0-9]+' | tail -4)
if [ -z "$signaturefile"]; then
  echo "Warning: no sha512 hash file found. skipping validation"
elif sha512sum --quiet -c $signaturefile; then
  echo "File succesfully validated!!!. [sha512 signature]"
else
  echo "File failed to validate ! [sha512 signature]"
  exit 1
fi

[[ -f alpine-minirootfs-armhf.tar.xz.sha512 ]] && \
if ! diff -q $signaturefile alpine-minirootfs-armhf.tar.xz.sha512 ; then
  echo "[INFO] File signatures are equal. Update not needed"
  [[ -f $HOME/.circlerc ]] && echo "export SKIP_BUILD=true" >>$HOME/.circlerc
  exit 0
fi
mv $signaturefile alpine-minirootfs-armhf.tar.xz.sha512
ALPINE_VERSION=$(sed -E 's@.*minirootfs-([0-9.]+)-armhf.*' <<<$rootfsfile)
[[ -f $HOME/.circlerc ]] && echo "export ALPINE_VERSION=$ALPINE_VERSION" >>$HOME/.circlerc
echo "New Alpine version detected $ALPINE_VERSION [Alpine]"

echo "Downloading [$alpineUrl$rootfsfile] to alpine-minirootfs-armhf.tar.xz"
[ -f alpine-minirootfs-armhf.tar.xz ] && rm alpine-minirootfs-armhf.tar.xz
wget $alpineUrl$rootfsfile -O alpine-minirootfs-armhf.tar.xz
