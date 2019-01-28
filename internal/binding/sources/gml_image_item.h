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

#ifndef GML_IMAGE_ITEM_H
#define GML_IMAGE_ITEM_H

#include "gml_includes.h"
#include "gml_error.h"
#include "gml_app.h"

class GmlImageItem : public QQuickPaintedItem
{
Q_OBJECT
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(Qt::TransformationMode transformationMode READ getTransformationMode WRITE setTransformationMode NOTIFY modeChanged)
    Q_PROPERTY(Qt::AspectRatioMode aspectRatioMode READ getAspectRatioMode WRITE setAspectRatioMode NOTIFY modeChanged)
    Q_PROPERTY(int imageWidth READ imageWidth NOTIFY imageSizeChanged)
    Q_PROPERTY(int imageHeight READ imageHeight NOTIFY imageSizeChanged)

public:
    GmlImageItem(QQuickItem *parent = nullptr);

    QString source() const;
    void    setSource(const QString &source);
    int     imageWidth();
    int     imageHeight();

    Qt::AspectRatioMode getAspectRatioMode();
    void                setAspectRatioMode(const Qt::AspectRatioMode m);

    Qt::TransformationMode getTransformationMode();
    void                   setTransformationMode(const Qt::TransformationMode m);

    void paint(QPainter *painter);
 
signals:
    void sourceChanged();
    void modeChanged();
    void imageSizeChanged();
    void painted();

private:
    QString src;
    QImage  img;
    Qt::TransformationMode transformationMode;
    Qt::AspectRatioMode    aspectRatioMode;
    int imgWidth, imgHeight;

private slots:
    void onRequestUpdate();
    void onImageItemChanged(const QString id);
    void onSourceChanged();

};

#endif
