#!/usr/bin/env bash

set -ex

ROOT=$PWD
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )"/.. && pwd )
cd $DIR


git --version

exit 0;

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

if [ "x$( git tag --list ${latest_rsyslog_tag} )" == "x" ]; then

  cd /tmp/rsyslog

  git checkout -b ${latest_rsyslog_tag}

  ./autogen.sh --enable-omkafka --disable-generate-man-pages --prefix=/tmp/rsyslog
  make && make install

  # cp /tmp/rsyslog/lib/rsyslog/omkafka.so ${output_folder}
  # cp $ROOT/$rsyslog_release/tag ${output_folder}
  # cp $ROOT/$rsyslog_release/tag ${output_folder}/name
  # touch ${output_folder}/note.md

  # Create release
  github-release release \
    --user hybris \
    --repo rsyslog-modules \
    --tag ${latest_rsyslog_tag} \
    --name "${latest_rsyslog_tag}"

  github-release upload \
    --user hybris \
    --repo rsyslog-modules \
    --tag ${latest_rsyslog_tag} \
    --name "omkakfa.so" \
    --file /tmp/rsyslog/lib/rsyslog/omkafka.so


fi
