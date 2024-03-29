FROM ubuntu:20.04
MAINTAINER team@desertbit.com

# Install dependencies.
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y update && \
    apt-get -y install build-essential sudo git wget nano make pkg-config \
        qt5-default qttools5-dev-tools qtdeclarative5-dev libqt5charts5-dev libqt5charts5 && \
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

