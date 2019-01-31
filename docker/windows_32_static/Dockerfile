FROM desertbit/gml:windows
MAINTAINER team@desertbit.com

ENV CROSS_TRIPLE="x86_64-w64-mingw32.static" \
    GOOS=windows \
    GOARCH=amd64

RUN cd /mxe && \
    export NUM_CORES="$(grep -c processor /proc/cpuinfo)" && \
    make -j${NUM_CORES} MXE_TARGETS="${CROSS_TRIPLE}" qtbase qtquickcontrols2

ENV PATH="/mxe/usr/bin:/mxe/usr/${CROSS_TRIPLE}/qt5/bin:$PATH" \
    PKG_CONFIG="/mxe/usr/bin/${CROSS_TRIPLE}-pkg-config" \
    PKG_CONFIG_PATH="/mxe/usr/${CROSS_TRIPLE}/qt5/lib/pkgconfig:$PKG_CONFIG_PATH"

