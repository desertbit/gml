# This file is auto-generated.
FROM therecipe/qt:windows_64_static

ENV CROSS_TRIPLE="x86_64-w64-mingw32.static"
ENV QT_ROOT="/usr/lib/mxe/usr/$CROSS_TRIPLE/qt5" \
    GOOS=windows \
    GOARCH=amd64

# Install dependencies.
RUN apt-get -y update && \
    apt-get -y install sudo git wget nano make && \
    apt-get -y clean

ENV PATH="/$QT_ROOT/bin:$PATH" \
    PKG_CONFIG_PATH="$QT_ROOT/lib/pkgconfig:$PKG_CONFIG_PATH" \
    LD_LIBRARY_PATH="$QT_ROOT/lib:$LD_LIBRARY_PATH"

# Install the Go compiler. We can't assure, that the go compiler is up-to-date from the base package.
RUN export GO_VERSION="1.11.4" && \
    export GO_CHECKSUM="fb26c30e6a04ad937bbc657a1b5bba92f80096af1e8ee6da6430c045a8db3a5b" && \
    rm -rf "$(go env GOROOT)" && \
    rm -rf /usr/local/go && \
    mkdir -p /tmp/go && \
    cd /tmp/go && \
    wget -O go.tar.gz https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz && \
    echo "${GO_CHECKSUM}  go.tar.gz" | sha256sum -c && \
    tar -xvf go.tar.gz && \
    mv go /usr/local && \
    rm -rf /tmp/go
ENV GOROOT=/usr/local/go \
    GOPATH=/work \
    CGO_ENABLED=1

# Install the gml tool.
RUN mkdir -p /tmp/go && cd /tmp/go && \
    export GOPATH="/tmp/go" && \
    export GOOS=linux && \
    export GOARCH=amd64 && \
    go get github.com/desertbit/gml/cmd/gml && \
    mv -f /tmp/go/bin/gml /bin/gml && \
    rm -rf /tmp/go

RUN mkdir /work
VOLUME /work
WORKDIR /work

ADD common/entrypoint.sh /entrypoint
RUN chmod +x /entrypoint
ENTRYPOINT ["/entrypoint"]
CMD ["gml"]

RUN mkdir -p /cross-bin && \
    export MXE_BIN="/usr/lib/mxe/usr/bin" && \
    ln -s "$MXE_BIN/$CROSS_TRIPLE-gcc" /cross-bin/gcc && \
    ln -s "$MXE_BIN/$CROSS_TRIPLE-strip" /cross-bin/strip
ENV PATH="/cross-bin:$PATH"
