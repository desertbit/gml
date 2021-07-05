#import templates/base

ENV CROSS_TRIPLE="x86_64-w64-mingw32.static" \
    GOOS=windows \
    GOARCH=amd64

#import templates/mxe

# TODO: deloy-dlls