// Copyright (c) 2024 Roland Singer, Sebastian Borchers
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

#include <go/go.h>

#include "imgprov.hpp"

//###############//
//### ImgProv ###//
//###############//

QQuickImageResponse* ImgProv::requestImageResponse(const QString& id, const QSize& requestedSize) {
    return new AsyncImageResponse(id, requestedSize, &m_threadPool);
}

//##########################//
//### AsyncImageResponse ###//
//##########################//

AsyncImageResponse::AsyncImageResponse(const QString& id, const QSize& requestedSize, QThreadPool *pool) {
    AsyncImageResponseRunnable* runnable = new AsyncImageResponseRunnable(id, requestedSize);
    connect(runnable, &AsyncImageResponseRunnable::done, this, &AsyncImageResponse::handleDone);
    pool->start(runnable);
}

void AsyncImageResponse::handleDone(QImage image) {
    m_image = image;
    emit finished();
}

QQuickTextureFactory* AsyncImageResponse::textureFactory() const {
    return QQuickTextureFactory::textureFactoryForImage(m_image);
}

//##################################//
//### AsyncImageResponseRunnable ###//
//##################################//

void AsyncImageResponseRunnable::run() {
    QImage image(50, 50, QImage::Format_RGB32);
    
    Test();
    if (m_id == QLatin1String("slow")) {
        image.fill(Qt::red);
    } else {
        image.fill(Qt::blue);
    }
    if (m_requestedSize.isValid())
        image = image.scaled(m_requestedSize);

    emit done(image);
}