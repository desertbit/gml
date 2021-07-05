#import templates/base

# Install dependencies.
RUN apt-get -y update && \
    apt-get -y install \
        qt5-default \
        qttools5-dev-tools \
        qtdeclarative5-dev && \
    apt-get -y clean
