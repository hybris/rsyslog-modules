#!/usr/bin/env bash

set -ex

ROOT=$PWD
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )
cd $DIR


RSYSLOG_VERSION=`cat $ROOT/$rsyslog_release/tag`

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

tar zxvf $ROOT/$rsyslog_release/source.tar.gz -C /tmp/rsyslog
cd /tmp/rsyslog
./autogen.sh --enable-omkafka --disable-generate-man-pages --prefix=/rsyslog_tmp
make && make install


# copy modules to shared volume
cp /rsyslog_tmp/lib/rsyslog/omkafka.so ${output_folder}
cp $ROOT/$rsyslog_release/tag ${output_folder}
cp $ROOT/$rsyslog_release/tag ${output_folder}/name
touch ${output_folder}/note.md
