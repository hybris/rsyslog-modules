#!/usr/bin/env bash

set -ex

ROOT=$PWD
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )
cd $DIR


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
latest_rsyslog_tag=`git tag --sort=-v:refname --list | head -1`

cd $DIR

if [ "x$( git tag --list ${latest_rsyslog_tag} )" != "x" ]; then

  cd /tmp/rsyslog

  git checkout -b ${latest_rsyslog_tag} refs/tags/${latest_rsyslog_tag}
  ./autogen.sh --enable-omkafka --disable-generate-man-pages --prefix=/rsyslog_tmp
  make && make install

  cp /rsyslog_tmp/lib/rsyslog/omkafka.so ${output_folder}
  cp $ROOT/$rsyslog_release/tag ${output_folder}
  cp $ROOT/$rsyslog_release/tag ${output_folder}/name
  touch ${output_folder}/note.md

fi






# copy modules to shared volume
