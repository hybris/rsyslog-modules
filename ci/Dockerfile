FROM ubuntu:trusty

RUN apt-get update && apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository ppa:git-core/ppa

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

    # Install Go
    RUN \
      mkdir -p /goroot && \
      curl https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz | tar xvzf - -C /goroot --strip-components=1

    # Set environment variables.
    ENV GOROOT /goroot
    ENV GOPATH /gopath
    ENV PATH $GOROOT/bin:$GOPATH/bin:$PATH

    RUN go get github.com/aktau/github-release
