FROM ubuntu:18.04
MAINTAINER team@desertbit.com

# Install dependencies.
RUN apt-get -y update && \
    apt-get -y install build-essential sudo git wget nano make pkg-config \
        qt5-default qttools5-dev-tools qtdeclarative5-dev libqt5charts5-dev libqt5charts5 && \
    apt-get -y clean

# Install the Go compiler.
RUN export GO_VERSION="1.16.5" && \
    export GO_CHECKSUM="b12c23023b68de22f74c0524f10b753e7b08b1504cb7e417eccebdd3fae49061" && \
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
    export VERSION="v0.0.22" && \
    mkdir -p "${GOPATH}/bin" && \
    cd /tmp/gml && \
    go mod init gml/build && \
    go get -v "github.com/desertbit/gml/cmd/gml@${VERSION}" && \
    go get -v "github.com/desertbit/gml/cmd/gml-copy-dlls@${VERSION}" && \
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

