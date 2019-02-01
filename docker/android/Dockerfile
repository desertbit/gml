FROM desertbit/gml:linux
MAINTAINER team@desertbit.com

# Install dependencies.
# http://doc.qt.io/qt-5/android-getting-started.html
RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt-get -y install unzip \
        libstdc++6:i386 libgcc1:i386 zlib1g:i386 libncurses5:i386 && \
    apt-get -y clean

# Install android NDK.
# https://developer.android.com/ndk/downloads/
RUN mkdir /tmp/ndk && cd /tmp/ndk && \
    export NDK_CHECKSUM="f02ad84cb5b6e1ff3eea9e6168037c823408c8ac" && \
    wget -O ndk.zip https://dl.google.com/android/repository/android-ndk-r19-linux-x86_64.zip && \
    echo "${NDK_CHECKSUM}  ndk.zip" | sha1sum -c && \
    unzip ndk.zip && \
    mv android-ndk-r19 /ndk && \
    rm -rf /tmp/ndk
ENV PATH="/ndk:$PATH"

# Patch NDK for gomobile.
# https://github.com/golang/go/issues/29706
RUN sed -i "s|flags = '-target {} -stdlib=libc++'.format(target)|flags = '-target {}'.format(target)|g" /ndk/build/tools/make_standalone_toolchain.py

# Install gomobile.
# https://github.com/golang/go/wiki/Mobile
ENV GOPATH="$GOPATH:/gomobile" \
    PATH="/gomobile/bin:$PATH"
RUN mkdir -p /gomobile && cd /gomobile && \
    export GOPATH="/gomobile" && \
    go get golang.org/x/mobile/cmd/gomobile && \
    gomobile init -ndk /ndk

# TODO: Finish this