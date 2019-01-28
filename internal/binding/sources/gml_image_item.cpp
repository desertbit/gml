/*
 * GML - Go QML
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2019 Roland Singer <roland.singer[at]desertbit.com>
 * Copyright (c) 2019 Sebastian Borchers <sebastian[at]desertbit.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "gml_image_item.h"

//########################//
//### Static Variables ###//
//########################//

gml_image_item_request_cb_t gml_image_item_request_cb = NULL;

//#############//
//### C API ###//
//#############//

void gml_image_item_request_cb_register(gml_image_item_request_cb_t cb) {
    gml_image_item_request_cb = cb;
}

void gml_image_item_emit_changed(const char* id) {
    try {
        emit GmlApp::App()->imageItemChanged(QString(id));
    }
    catch (std::exception& e) {
        gml_error_log_exception(e.what());
    }
    catch (...) {
        gml_error_log_exception();
    }
}

//##########################//
//### GmlImageItem Class ###//
//##########################//

GmlImageItem::GmlImageItem(QQuickItem *parent) :
    QQuickPaintedItem(parent),
    src(""),
    transformationMode(Qt::FastTransformation),
    aspectRatioMode(Qt::KeepAspectRatio),
    imgWidth(0),
    imgHeight(0)
{
    QObject::connect(GmlApp::App(), &GmlApp::imageItemChanged,
                     this, &GmlImageItem::onImageItemChanged);
    QObject::connect(this, &GmlImageItem::sourceChanged,
		             this, &GmlImageItem::onSourceChanged);
    QObject::connect(this, &GmlImageItem::modeChanged,
		             this, &GmlImageItem::onRequestUpdate);
}

QString GmlImageItem::source() const {
    return src;
}

void GmlImageItem::setSource(const QString &source) {
    this->src = source;
    emit sourceChanged();
}

int GmlImageItem::imageWidth() {
    return imgWidth;
}

int GmlImageItem::imageHeight() {
    return imgHeight;
}

Qt::AspectRatioMode GmlImageItem::getAspectRatioMode() {
    return aspectRatioMode;
}

void GmlImageItem::setAspectRatioMode(const Qt::AspectRatioMode m) {
    aspectRatioMode = m;
    emit modeChanged();
}

Qt::TransformationMode GmlImageItem::getTransformationMode() {
    return transformationMode;
}

void GmlImageItem::setTransformationMode(const Qt::TransformationMode m) {
    transformationMode = m;
    emit modeChanged();
}

void GmlImageItem::onRequestUpdate() {
    update();
}

void GmlImageItem::onImageItemChanged(const QString id) {
    if (this->src != id) {
        return;
    }

    onSourceChanged();
}

void GmlImageItem::onSourceChanged() {
    // Call to go.
    try {
        gml_image_item_request_cb(
            src.toLocal8Bit().data(),
            (gml_image)(&img)
        );
    }
    catch (std::exception& e) {
        gml_error_log_exception("image item request: " + string(e.what()));
    }
    catch (...) {
        gml_error_log_exception("image item request");
    }

    // Repaint.
    update();
}

void GmlImageItem::paint(QPainter *painter) {
    if (img.isNull()) {
        return;
    }
    
    QRectF bRect   = boundingRect();
    QImage scaled  = img.scaled(bRect.width(), bRect.height(), aspectRatioMode, transformationMode);
    QPointF center = bRect.center() - scaled.rect().center();

    // Ensure the image is centered.
    if (center.x() < 0) {
        center.setX(0);
    }
    if (center.y() < 0) {
        center.setY(0);
    }

    // Notify, if the size has changed.
    int w = scaled.width();
    int h = scaled.height();
    if (w != imgWidth || h != imgHeight) {
        imgWidth = w;
        imgHeight = h;
        emit imageSizeChanged();
    }

    painter->drawImage(center, scaled);
    emit painted();
}

