#!/usr/bin/env bash
set -xe
$SKIP_BUILD && exit 0
echo "Building the Dockerfile"
docker build .
