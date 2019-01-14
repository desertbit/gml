FROM desertbit/crossbuild:linux-x86_64

# Install dependencies. Nasm is required for ffmpeg.
RUN apt-get -y update && \
    apt-get -y install nasm && \
    apt-get -y clean

RUN export QT_BRANCH="stable" && \
    mkdir -p /tmp/qt && cd /tmp/qt && \
    git clone --depth 1 --single-branch -b "${QT_BRANCH}" https://code.qt.io/qt/qt5.git && \
    cd qt5 && /
    rm -rf /tmp/qt