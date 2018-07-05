#!/usr/bin/env bash
set -xe
$SKIP_BUILD && exit 0
#update the readme
sed -Ei "s@(Latest image is version)\s+[0-9.]+@\1 $ALPINE_VERSION@" README.md
sed -Ei "s@(https://alpinelinux.org/posts/Alpine-)[0-9.]+(-released.html)@\1$ALPINE_VERSION\2@g" README.md

git config --global user.email $CIRCLE_USERNAME
git config --global user.name "CircleCI"
git add -v .
git commit -m "[ci skip] updated alpine to version $ALPINE_VERSION."
git tag "$ALPINE_VERSION"
git push origin master
git push --tags origin master
curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/aalaesar/arm32v7-alpine/trigger/$DOCKERHUBKEY/
