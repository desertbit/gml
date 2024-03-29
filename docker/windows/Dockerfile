FROM ubuntu:20.04
MAINTAINER team@desertbit.com

# Install dependencies.
# https://mxe.cc/#requirements
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y update && \
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
        python3-mako \
        ruby \
        sed \
        unzip \
        wget \
        xz-utils && \
    apt-get -y clean

# Install the Go compiler.
RUN export GO_VERSION="1.21.4" && \
    export GO_CHECKSUM="73cac0215254d0c7d1241fa40837851f3b9a8a742d0b54714cbdfb3feaf8f0af" && \
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
RUN export GOPATH="/tmp/gml/go" && \
    export GOOS=linux && \
    export GOARCH=amd64 && \
    export VERSION="v0.0.38" && \
    mkdir -p "${GOPATH}/bin" && \
    cd /tmp/gml && \
    go install "github.com/desertbit/gml/cmd/gml@${VERSION}" && \
    go install "github.com/desertbit/gml/cmd/gml-copy-dlls@${VERSION}" && \
    mv "${GOPATH}/bin/gml" /bin/gml && \
    mv "${GOPATH}/bin/gml-copy-dlls" /bin/gml-copy-dlls && \
    rm -rf /tmp/gml

RUN mkdir /work
VOLUME /work
WORKDIR /work

ADD common/entrypoint.sh /entrypoint
RUN chmod +x /entrypoint
ENTRYPOINT ["/entrypoint"]
CMD ["gml"]


# https://mxe.cc
# https://stackoverflow.com/questions/14170590/building-qt-5-on-linux-for-windows/14170591#14170591
# Version Master
RUN export MXE_COMMIT="6f1727478aeb8981eaf5a9b82c8bc87c5fd3e20c" && \
    git clone https://github.com/mxe/mxe.git /mxe && \
    cd /mxe && \
    git checkout "${MXE_COMMIT}"

