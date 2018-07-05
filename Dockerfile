FROM alpine:latest as extractor
WORKDIR /myalpine
ADD http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/armhf/alpine-minirootfs-3.8.0-armhf.tar.gz .
RUN tar -xzf alpine-minirootfs-3.8.0-armhf.tar.gz

FROM scratch
WORKDIR /
LABEL architecture="ARM32v7"
COPY --from=extractor /myalpine/ .
CMD ["/bin/sh"]
