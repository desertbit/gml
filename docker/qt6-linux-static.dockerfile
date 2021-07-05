#import templates/base

# Install dependencies.
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y update && \
    apt-get -y install \
        tzdata \
        python \
        cmake \
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
RUN export QT_MAJOR="6.0" && \
    export QT_VERSION="6.0.0" && \
    export QT_CHECKSUM="794aae9cc11898a648e671c7365b8623" && \
    mkdir -p /tmp/qt && \
    cd /tmp/qt && \
    wget -O qt.tar.xz https://download.qt.io/official_releases/qt/${QT_MAJOR}/${QT_VERSION}/single/qt-everywhere-src-${QT_VERSION}.tar.xz && \
    echo "${QT_CHECKSUM}  qt.tar.xz" | md5sum -c && \
    tar -xf qt.tar.xz && \
    mv qt-everywhere-src-${QT_VERSION} src && \
    mkdir build && cd build && \
    ../src/configure \
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
        -qt-freetype \
        -qt-pcre \
        -qt-harfbuzz \
        -nomake tools \
        -nomake examples \
        -nomake tests \
        -no-pch \
        -skip qtwebengine && \
    cmake --build . --parallel && \
    cmake --install . && \
    rm -rf /tmp/qt
