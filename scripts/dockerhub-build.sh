#!/usr/bin/env bash
$SKIP_BUILD && exit 0
sed -Ei "s@(Latest image is version)\s+[0-9.]+@\1 $ALPINE_VERSION@"
git config --global user.email $CIRCLE_USERNAME
git config --global user.name "CircleCI"
      git add -v .
git commit -m "[ci skip] updated and built alpine to version $ALPINE_VERSION."
git push origin master
curl -H "Content-Type: application/json" --data '{"build": true}' -X POST https://registry.hub.docker.com/u/aalaesar/arm32v7-alpine/trigger/$DOCKERHUBKEY/
