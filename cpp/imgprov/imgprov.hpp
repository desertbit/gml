// Copyright (c) 2024 Roland Singer, Sebastian Borchers
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

#pragma once

#include <QString>
#include <QSize>
#include <QImage>
#include <QThreadPool>
#include <QQuickImageResponse>
#include <QQuickAsyncImageProvider>

// The actual image provider class.
// We subclass the async variant to enforce loading in a low-priority thread,
// regardless of the type of image being requested.
class ImgProv : public QQuickAsyncImageProvider {
public:
    QQuickImageResponse* requestImageResponse(const QString& id, const QSize& requestedSize) override;

private:
    QThreadPool m_threadPool;
};

// The asynchronous image response object.
class AsyncImageResponse : public QQuickImageResponse {
public:
    AsyncImageResponse(const QString& id, const QSize& requestedSize, QThreadPool *pool);

    void handleDone(QImage image);

    QQuickTextureFactory* textureFactory() const override;

private:
    QImage m_image;
};

// The thread implementation of the image response.
class AsyncImageResponseRunnable : public QObject, public QRunnable {
    Q_OBJECT

signals:
    void done(QImage image);

public:
    AsyncImageResponseRunnable(const QString& id, const QSize& requestedSize)
        : m_id(id), m_requestedSize(requestedSize) {}

    void run();

private:
    QString m_id;
    QSize m_requestedSize;
};