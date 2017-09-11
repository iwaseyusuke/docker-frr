# FRRouting

FROM ubuntu:16.04

MAINTAINER IWASE Yusuke <iwase.yusuke0@gmail.com>
ARG user=iwaseyusuke
ARG branch_name=frr-2.0

USER root
WORKDIR /root

COPY ENTRYPOINT.sh /ENTRYPOINT.sh

# Install dependencies
RUN apt-get update && apt-get install -yq --no-install-recommends \
    git \
    autoconf \
    automake \
    bison \
    fakeroot \
    flex \
    gcc \
    libc-ares-dev \
    libjson-c-dev \
    libpam0g-dev \
    libsystemd-dev \
    libpython-dev \
    libreadline-dev \
    libtool \
    make \
    pkg-config \
# For editing configurations
    vim \
# Utilities
    iputils-ping \
    tcpdump \
 && rm -rf /var/lib/apt/lists/* \
 && mv /bin/ping /sbin/ping \
 && mv /bin/ping6 /sbin/ping6 \
 && mv /usr/sbin/tcpdump /usr/bin/tcpdump \
# Clone Git sources
 && export GIT_SSL_NO_VERIFY=true \
 && git clone -b $branch_name --single-branch https://github.com/frrouting/frr.git \
# Build & Install
 && cd frr \
 && ./bootstrap.sh \
 && ./configure \
    --enable-exampledir=/usr/share/doc/frr/examples/ \
    --localstatedir=/var/run/frr \
    --sbindir=/usr/lib/frr \
    --sysconfdir=/etc/frr \
    --enable-vtysh \
    --enable-isisd \
    --enable-pimd \
    --enable-watchfrr \
    --enable-ospfclient=yes \
    --enable-ospfapi=yes \
    --enable-multipath=64 \
    --enable-user=root \
    --enable-group=root \
    --enable-vty-group=root \
    --enable-configfile-mask=0640 \
    --enable-logfile-mask=0640 \
    --enable-rtadv \
    --enable-fpm \
    --enable-ldpd \
    --enable-systemd \
    --disable-doc \
 && make && make install \
# Re-configure LD_LIBRARY_PATH
 && echo '/usr/local/lib' > /etc/ld.so.conf.d/usr_local_lib.conf \
 && ldconfig \
# Prepare configuration files and directories
 && mkdir -p /var/log/frr \
 && mkdir -p /etc/frr \
 && touch /etc/frr/zebra.conf \
 && touch /etc/frr/bgpd.conf \
 && touch /etc/frr/ospfd.conf \
 && touch /etc/frr/ospf6d.conf \
 && touch /etc/frr/isisd.conf \
 && touch /etc/frr/ripd.conf \
 && touch /etc/frr/ripngd.conf \
 && touch /etc/frr/pimd.conf \
 && touch /etc/frr/ldpd.conf \
 && touch /etc/frr/nhrpd.conf \
 && touch /etc/frr/vtysh.conf \
 && cp /root/frr/cumulus/etc/frr/debian.conf /etc/frr/debian.conf \
 && cp /root/frr/cumulus/etc/frr/daemons     /etc/frr/daemons \
# Prepare init.d script
 && cp /root/frr/tools/frr /etc/init.d/ \
 && sed -i "s/frr:frr/root:root/" /etc/init.d/frr \
# Prepare ENTRYPOINT.sh
 && chmod +x /ENTRYPOINT.sh

ENTRYPOINT ["/ENTRYPOINT.sh"]
