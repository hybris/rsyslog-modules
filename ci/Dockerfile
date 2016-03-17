FROM ubuntu:trusty

RUN apt-get update && apt-get install -y \
      git \
      build-essential \
      automake \
      dh-autoreconf \
      libestr-dev \
      libjson-c-dev \
      uuid-dev \
      pkg-config \
      zlib1g-dev \
      libgcrypt11-dev \
      librdkafka-dev \
      flex \
      bison \
      python-docutils && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*
