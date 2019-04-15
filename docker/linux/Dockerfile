FROM ubuntu:18.04
MAINTAINER team@desertbit.com

# Install dependencies.
RUN apt-get -y update && \
    apt-get -y install build-essential sudo git wget nano make pkg-config \
        qt5-default qttools5-dev-tools qtdeclarative5-dev && \
    apt-get -y clean

# Install the Go compiler.
RUN export GO_VERSION="1.12.4" && \
    export GO_CHECKSUM="d7d1f1f88ddfe55840712dc1747f37a790cbcaa448f6c9cf51bbe10aa65442f5" && \
    mkdir -p /tmp/go && \
    cd /tmp/go && \
    wget -O go.tar.gz https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz && \
    echo "${GO_CHECKSUM}  go.tar.gz" | sha256sum -c && \
    tar -xvf go.tar.gz && \
    mv go /usr/local && \
    rm -rf /tmp/go
ENV PATH="$PATH:/usr/local/go/bin" \
    GOROOT=/usr/local/go \
    GOPATH=/work \
    CGO_ENABLED=1

# Install the gml tool.
RUN mkdir -p /tmp/go && cd /tmp/go && \
    export GOPATH="/tmp/go" && \
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

