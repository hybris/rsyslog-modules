#!/usr/bin/env bash

set -e

RSYSLOG_VERSION=${RSYSLOG_VERSION:-""}

git clone https://github.com/rsyslog/liblogging.git /tmp/liblogging
cd /tmp/liblogging
autoreconf -fvi
./configure
make && make install

git clone https://github.com/rsyslog/libfastjson.git /tmp/libfastjson
cd /tmp/libfastjson
sh autogen.sh
./configure
make && make install

git clone https://github.com/rsyslog/rsyslog.git /tmp/rsyslog
cd /tmp/rsyslog
if [ "${RSYSLOG_VERSION}" != "" ]; then
  git checkout -b ${RSYSLOG_VERSION} refs/tags/${RSYSLOG_VERSION}
fi
./autogen.sh --enable-omkafka --disable-generate-man-pages --prefix=/rsyslog_tmp
make && make install


# copy modules to shared volume
cp /rsyslog_tmp/lib/rsyslog/omkafka.so /rsyslog_libs
