#!/usr/bin/env bash
apk add --update curl   \
    bash \
    qemu-system-x86_64 

addgroup $USER kvm
rm -rf /var/cache/apk/*
