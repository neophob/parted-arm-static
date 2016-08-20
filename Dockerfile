# source: https://github.com/petrosagg/armv7hf-python-dockerhub/blob/master/Dockerfile

FROM resin/armv7hf-debian-qemu

RUN [ "cross-build-start" ]

ENV PARTED_VERSION 3.2

RUN apt-get update && apt-get install -y \
		autoconf \
		build-essential \
		ca-certificates \
		curl \
		zlib1g-dev

RUN apt-get install -y \
    libdevmapper-dev \
    libncurses-dev \
    libuuid1 \
    libblkid1 \
    e2fslibs \
    uuid-dev \
    e2fsprogs \
    libreadline6 \
    libreadline6-dev \
    util-linux \
	&& rm -rf /var/lib/apt/lists/*

ADD parted.patch /

#CFLAGS = "--disable-dynamic-loading --enable-all-static --disable-pc98"
#parted_LDFLAGS=-all-static
RUN set -x \
	&& mkdir -p /parted \
  && mkdir -p /dist \
  && cd /parted \
	&& curl -SL "http://ftp.gnu.org/gnu/parted/parted-${PARTED_VERSION}.tar.xz" -o parted.tar.xz \
	&& tar -xf parted.tar.xz \
  && cd parted-${PARTED_VERSION} \
  && patch -Np1 -i /parted.patch \
	&& ./configure --enable-static --enable-static=yes --without-readline --enable-all-static --disable-dynamic-loading --disable-shared --disable-dynamic-loading --disable-debug --disable-rpath --disable-device-mapper --disable-nls --prefix=/dist \
	&& LDFLAGS=-all-static make \
	&& make install \
  && echo "show dist:" \
  && ls -al /dist

RUN [ "cross-build-end" ]
