FROM scratch
MAINTAINER Aalaesar <aalaesar@gmail.com>
LABEL architecture="ARM32v7"

ADD http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/armhf/alpine-minirootfs-3.8.0-armhf.tar.gz /
CMD ["/bin/bash"]
