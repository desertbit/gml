#import templates/base

# Install dependencies.
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y update && \
    apt-get -y install \
        tzdata \
        python \
        libgl1-mesa-dev \
        libglu1-mesa-dev \
        libfontconfig1-dev \
        libfreetype6-dev \
        libx11-dev \
        libxext-dev \
        libxfixes-dev \
        libxi-dev \
        libxrender-dev \
        libxcb1-dev \
        libx11-xcb-dev \
        libxcb-glx0-dev \
        libxkbcommon-dev \
        libxkbcommon-x11-dev \
        '^libxcb.*-dev' \
        libinput-dev && \
    apt-get -y clean

# Build Qt.
RUN export QT_MAJOR="5.15" && \
    export QT_VERSION="5.15.1" && \
    export QT_CHECKSUM="44da876057e21e1be42de31facd99be7d5f9f07893e1ea762359bcee0ef64ee9" && \
    export NUM_CORES="$(grep -c processor /proc/cpuinfo)" && \
    mkdir -p /tmp/qt && \
    cd /tmp/qt && \
    wget -O qt.tar.xz https://download.qt.io/official_releases/qt/${QT_MAJOR}/${QT_VERSION}/single/qt-everywhere-src-${QT_VERSION}.tar.xz && \
    echo "${QT_CHECKSUM}  qt.tar.xz" | sha256sum -c && \
    tar -xf qt.tar.xz && \
    cd qt-everywhere-src-${QT_VERSION} && \
    ./configure \
        -prefix "/usr/local" \
        -static \
        -opensource \
        -confirm-license \
        -release \
        -optimize-size \
        -strip \
        -fontconfig \
        -libinput \
        -qt-zlib \
        -qt-libjpeg \
        -qt-libpng \
        -qt-pcre \
        -qt-harfbuzz \
        -qt-doubleconversion \
        -nomake tools \
        -nomake examples \
        -nomake tests \
        -no-pch \
        -skip qtwebengine && \
    make -j${NUM_CORES} && \
    make install -j${NUM_CORES} && \
    rm -rf /tmp/qt
