FROM desertbit/gml:linux
MAINTAINER team@desertbit.com

# Install dependencies.
# http://doc.qt.io/qt-5/android-getting-started.html
RUN apt-get -y update && \
    apt-get -y install android-sdk && \
    apt-get -y clean

# TODO: finish this
# Install android NDK
# https://developer.android.com/ndk/downloads/
RUN mkdir /tmp/ndk && cd /tmp/ndk && \
    wget https://dl.google.com/android/repository/android-ndk-r19-linux-x86_64.zip && \
    rm -rf /tmp/ndk
