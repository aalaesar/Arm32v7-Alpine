#!/usr/bin/env bash
$SKIP_BUILD && exit 0
echo "Building the Dockerfile"
docker build .
