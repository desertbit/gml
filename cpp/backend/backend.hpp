// Copyright (c) 2024 Roland Singer, Sebastian Borchers
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QString>
#include <QTranslator>

//Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)

class Backend : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public slots:
    bool switchLocale(const QString& locale);

public:
    explicit Backend(QObject *parent = nullptr);

private:
    QTranslator m_translator;
};