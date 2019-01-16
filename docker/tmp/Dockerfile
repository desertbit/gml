RUN export QT_TAG="v5.12.0" && \
    export NUM_CORES="$(grep -c processor /proc/cpuinfo)" && \
    mkdir -p /tmp/qt && cd /tmp/qt && \
    git clone --depth 1 --single-branch -b "${QT_TAG}" https://code.qt.io/qt/qt5.git && \
    cd qt5 && \
    ./init-repository \
        --module-subset=essential,addon,-qtwebengine && \
    ./configure -prefix="${CROSS_SYSROOT}/usr/" \
        -device linux-rasp-pi-g++ \
        -device-option CROSS_COMPILE="${CROSS_TRIPLE}-" \
        #-sysroot /opt/qt5pi/sysroot \
        -opensource \
        -confirm-license \
        -release \
        -nomake tests \
        -nomake examples && \
    make -j${NUM_CORES} module-qtbase module-qtquickcontrols2 && \
    make install && \
    rm -rf /tmp/qt


    -opengl es2 -device linux-rasp-pi-g++ 
    -sysroot /opt/qt5pi/sysroot -prefix /usr/local/qt5pi 
