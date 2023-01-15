FROM desertbit/gml:windows
MAINTAINER team@desertbit.com

ENV CROSS_TRIPLE="i686-w64-mingw32.shared" \
    GOOS=windows \
    GOARCH=386

# TODO: Remove DONT_CHECK_REQUIREMENTS=1
# See https://github.com/mxe/mxe/issues/2907 why this is necessary now.
RUN cd /mxe && \
    export NUM_CORES="$(grep -c processor /proc/cpuinfo)" && \
    make -j${NUM_CORES} MXE_TARGETS="${CROSS_TRIPLE}" qtbase qtquickcontrols qtquickcontrols2 qtimageformats qtlocation qtcharts qtgraphicaleffects qtvirtualkeyboard DONT_CHECK_REQUIREMENTS=1

ENV PATH="/mxe/usr/bin:/mxe/usr/${CROSS_TRIPLE}/qt5/bin:$PATH" \
    PKG_CONFIG="/mxe/usr/bin/${CROSS_TRIPLE}-pkg-config" \
    PKG_CONFIG_PATH="/mxe/usr/${CROSS_TRIPLE}/qt5/lib/pkgconfig:$PKG_CONFIG_PATH" \
    CC="${CROSS_TRIPLE}-gcc" \
    CXX="${CROSS_TRIPLE}-g++"

# Patch to include some missing libraries for cgo. Otherwise the linker fails.
RUN sed -i "s|Libs.private:|Libs.private: -lstdc++ |g" "/mxe/usr/${CROSS_TRIPLE}/qt5/lib/pkgconfig/Qt5Core.pc"
ADD common/deploy-dlls.sh /bin/deploy-dlls
RUN chmod +x /bin/deploy-dlls
ENV GML_BUILD_POST_HOOKS="/bin/deploy-dlls"

