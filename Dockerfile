FROM scratch
MAINTAINER Aalaesar <aalaesar@gmail.com>
LABEL architecture="ARM32v7"

ADD alpine-minirootfs-armhf.tar.xz /
CMD ["/bin/bash"]
