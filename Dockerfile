FROM scratch
MAINTAINER Aalaesar <aalaesar@gmail.com>
LABEL architecture="ARM32v7"

ADD http://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/armhf/alpine-minirootfs-armhf.tar.xz /
CMD ["/bin/bash"]
