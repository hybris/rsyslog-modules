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


git clone https://github.com/rsyslog/rsyslog.git /${output_folder}
cd /${output_folder}
latest_rsyslog_tag=`git tag --sort=-v:refname --list | head -1`

cd $DIR

if [ "x$( git tag --list ${latest_rsyslog_tag} )" = "x" ]; then

  cd /${output_folder}

  git checkout -b ${latest_rsyslog_tag} refs/tags/${latest_rsyslog_tag}
  ./autogen.sh --enable-omkafka --disable-generate-man-pages --prefix/=${output_folder}
  make && make install

  # cp /${output_folder}/lib/rsyslog/omkafka.so ${output_folder}
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
    --file ${output_folder}


fi
