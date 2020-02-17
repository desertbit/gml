FROM ubuntu:18.04
MAINTAINER team@desertbit.com

# Install dependencies.
# https://mxe.cc/#requirements
RUN apt-get -y update && \
    apt-get -y install \
        sudo \
        nano \
        autoconf \
        automake \
        autopoint \
        bash \
        bison \
        bzip2 \
        flex \
        g++ \
        g++-multilib \
        gettext \
        git \
        gperf \
        intltool \
        libc6-dev-i386 \
        libgdk-pixbuf2.0-dev \
        libltdl-dev \
        libssl-dev \
        libtool-bin \
        libxml-parser-perl \
        lzip \
        make \
        openssl \
        p7zip-full \
        patch \
        perl \
        pkg-config \
        python \
        ruby \
        sed \
        unzip \
        wget \
        xz-utils && \
    apt-get -y clean

# Install the Go compiler.
RUN export GO_VERSION="1.13.8" && \
    export GO_CHECKSUM="0567734d558aef19112f2b2873caa0c600f1b4a5827930eb5a7f35235219e9d8" && \
    mkdir -p /tmp/go && \
    cd /tmp/go && \
    wget -O go.tar.gz https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz && \
    echo "${GO_CHECKSUM}  go.tar.gz" | sha256sum -c && \
    tar -xvf go.tar.gz && \
    mv go /usr/local && \
    rm -rf /tmp/go
ENV PATH="$PATH:/usr/local/go/bin" \
    GOROOT=/usr/local/go \
    CGO_ENABLED=1

# Install the gml tool.
RUN mkdir -p /tmp/go && cd /tmp/go && \
    export GOPATH="/tmp/go" && \
    export GOCACHE="/tmp/go/cache" && \
    export GOOS=linux && \
    export GOARCH=amd64 && \
    go get github.com/desertbit/gml/cmd/... && \
    mv -f /tmp/go/bin/gml /bin/gml && \
    mv -f /tmp/go/bin/gml-copy-dlls /bin/gml-copy-dlls && \
    rm -rf /tmp/go

RUN mkdir /work
VOLUME /work
WORKDIR /work

ADD common/entrypoint.sh /entrypoint
RUN chmod +x /entrypoint
ENTRYPOINT ["/entrypoint"]
CMD ["gml"]


# https://mxe.cc
# https://stackoverflow.com/questions/14170590/building-qt-5-on-linux-for-windows/14170591#14170591
RUN export MXE_COMMIT="5fa54789ffb38ccd5a78b5166e6c0d5b94c40c04" && \
    git clone https://github.com/mxe/mxe.git /mxe && \
    cd /mxe && \
    git checkout "${MXE_COMMIT}"

