FROM archlinux/base:latest
MAINTAINER team@desertbit.com

ENV WINEPATH=C:\\mingw64\\bin;C:\\usr\\bin
ENV WINEPREFIX=/wine
ENV WINEROOT=/wine/drive_c

RUN mkdir -p ${WINEPREFIX} && \
    mkdir -p ${WINEROOT}/var/lib/pacman

# Copy our pacman configs.
COPY windows_wine/pacman.conf /etc/pacman.conf
COPY windows_wine/pacman-msys2.conf /etc/pacman-msys2.conf

# Install dependencies.
RUN pacman-key --init && \
    pacman -Syu --noconfirm \
        sudo \
        git \
        tar \
        xz \
        unzip \
        nano \
        awk \
        wget \
        wine \
        winetricks \
        mpg123 \
        lib32-mpg123 \
        ncurses \
        lib32-ncurses \
        xorg-server-xvfb && \
    pacman -Scc --noconfirm

# Setup wine.
RUN WINEDLLOVERRIDES="mscoree,mshtml=" xvfb-run wineboot && wineserver -w && \
    xvfb-run winetricks -q vcrun2015

# Install the msys2 gpg keys.
# https://github.com/Alexpux/MSYS2-keyring
COPY windows_wine/msys2.gpg /usr/share/pacman/keyrings/
COPY windows_wine/msys2-trusted /usr/share/pacman/keyrings/
RUN pacman-key --populate msys2

# TODO: Install pacman first?
# TODO: Also add a mssy2 install command? (Without -Sy)

# Install msys2 packages.
RUN pacman --config /etc/pacman-msys2.conf -Sy \
        --noconfirm \
        --noscriptlet \
        base-devel \
        msys2-devel \
        git \
        go \
        mingw-w64-x86_64-qt5

# Install msys2.
#RUN export MSYS2_VERSION="20190524" && \
#    export MSYS2_CHECKSUM="168e156fa9f00d90a8445676c023c63be6e82f71487f4e2688ab5cb13b345383" && \
#    mkdir -p /tmp/msys2 && \
#    cd /tmp/msys2 && \
#    wget -O msys2.tar.xz http://repo.msys2.org/distrib/x86_64/msys2-base-x86_64-${MSYS2_VERSION}.tar.xz && \
#    echo "${MSYS2_CHECKSUM}  msys2.tar.xz" | sha256sum -c && \
#    tar -xvf msys2.tar.xz && \
#    mv msys64 ${WINEROOT}/msys64 && \
#    rm -rf /tmp/msys2

#RUN mkdir /work
#VOLUME /work
#WORKDIR /work
