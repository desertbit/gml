// Copyright (c) 2024 Roland Singer, Sebastian Borchers
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

#include "backend.hpp"

#include <QCoreApplication>
#include <QQmlEngine>
#include <QQmlContext>
#include <QDirIterator>

Backend::Backend(QObject* parent) : QObject(parent) {
    QCoreApplication::installTranslator(&m_translator);
}

bool Backend::switchLocale(const QString& locale) {
    // Load the tr file for this locale.
    bool success = m_translator.load(QStringLiteral(":/translations/app_") + locale);
    if (!success) {
        qCritical("Backend::switchLocale: failed to load translation");
        return false;
    }

    // Retrieve the context.
    QQmlContext* ctx = QQmlEngine::contextForObject(this);
    if (ctx == nullptr) {
        qCritical("Backend::switchLocale: failed to get context");
        return false;
    }

    // Retrieve the application engine.
    QQmlEngine* engine = ctx->engine();
    if (engine == nullptr) {
        qCritical("Backend::switchLocale: failed to get engine");
        return false;
    }

    // Refresh all binding expressions that use strings marked for translation.
    engine->retranslate();
    return true;
}
