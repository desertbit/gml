// Copyright (c) 2024 Roland Singer, Sebastian Borchers
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

#include "imgprov.hpp"

#include <QQmlExtensionPlugin>

class ImgProvPlugin : public QQmlEngineExtensionPlugin {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlEngineExtensionInterface_iid)

public:
    void initializeEngine(QQmlEngine *engine, const char *uri) final {
        Q_UNUSED(uri);
        engine->addImageProvider("imgprov", new ImgProv);
    }
};

// This must come after the declaration of our plugin class!
#include "plugin.moc"
