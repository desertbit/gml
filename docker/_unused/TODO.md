# Docker TODO

## Windows Static Builds

```cpp
Q_IMPORT_PLUGIN(QWindowsIntegrationPlugin) // TODO: only if windows build.
Q_IMPORT_PLUGIN(QMinimalIntegrationPlugin)
Q_IMPORT_PLUGIN(QGifPlugin)
Q_IMPORT_PLUGIN(QICOPlugin)
Q_IMPORT_PLUGIN(QJpegPlugin)
Q_IMPORT_PLUGIN(QGenericEnginePlugin)
Q_IMPORT_PLUGIN(QtQuick2Plugin)
Q_IMPORT_PLUGIN(QtQuickLayoutsPlugin)
Q_IMPORT_PLUGIN(QtQuickControls2Plugin)
// ...
```

Generate this dynamically and prepend it to the docker ENV:

```
// #cgo LDFLAGS: -lstdc++ /mxe/usr/x86_64-w64-mingw32.static/qt5/qml/QtQuick/Controls.2/libqtquickcontrols2plugin.a /mxe/usr/x86_64-w64-mingw32.static/qt5/qml/QtQuick.2/libqtquick2plugin.a /mxe/usr/x86_64-w64-mingw32.static/qt5/qml/QtQuick/Layouts/libqquicklayoutsplugin.a -L/mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/platforms -lqminimal -lqwindows -ldwmapi -lwinspool -lwtsapi32 -lQt5EventDispatcherSupport -L/mxe/usr/x86_64-w64-mingw32.static/lib/../lib -lQt5FontDatabaseSupport -lQt5ThemeSupport -lQt5AccessibilitySupport -lQt5WindowsUIAutomationSupport -lQt5Gui -lharfbuzz -lcairo -lgobject-2.0 -lfontconfig -lfreetype -lm -lusp10 -lmsimg32 -lpixman-1 -lffi -lexpat -lbz2 -lpng16 -lharfbuzz_too -lfreetype_too -lglib-2.0 -lshlwapi -lpcre -lintl -liconv -lgdi32 -lcomdlg32 -loleaut32 -limm32 -lopengl32 -lQt5Core -lmpr -lnetapi32 -luserenv -lversion -lws2_32 -lkernel32 -luser32 -lshell32 -luuid -lole32 -ladvapi32 -lwinmm -lz -lpcre2-16 -lopengl32            -L/mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/platforms /mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/platforms/libqminimal.a -L/mxe/usr/x86_64-w64-mingw32.static/qt5/lib /mxe/usr/x86_64-w64-mingw32.static/qt5/lib/libQt5EventDispatcherSupport.a -L/mxe/usr/x86_64-w64-mingw32.static/lib /mxe/usr/x86_64-w64-mingw32.static/qt5/lib/libQt5FontDatabaseSupport.a -L/mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/imageformats /mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/imageformats/libqgif.a /mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/imageformats/libqico.a /mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/imageformats/libqjpeg.a -ljpeg -L/mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/qmltooling /mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/qmltooling/libqmldbg_debugger.a /mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/qmltooling/libqmldbg_inspector.a /mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/qmltooling/libqmldbg_local.a /mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/qmltooling/libqmldbg_messages.a /mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/qmltooling/libqmldbg_native.a /mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/qmltooling/libqmldbg_nativedebugger.a /mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/qmltooling/libqmldbg_preview.a /mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/qmltooling/libqmldbg_profiler.a /mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/qmltooling/libqmldbg_quickprofiler.a /mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/qmltooling/libqmldbg_server.a /mxe/usr/x86_64-w64-mingw32.static/qt5/lib/libQt5PacketProtocol.a /mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/qmltooling/libqmldbg_tcp.a -L/mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/bearer /mxe/usr/x86_64-w64-mingw32.static/qt5/plugins/bearer/libqgenericbearer.a /mxe/usr/x86_64-w64-mingw32.static/qt5/lib/libQt5Quick.a /mxe/usr/x86_64-w64-mingw32.static/qt5/lib/libQt5Gui.a -lharfbuzz -lcairo -lgobject-2.0 -lfontconfig -lfreetype -lm -lusp10 -lmsimg32 -lpixman-1 -lffi -lexpat -lbz2 -lpng16 -lharfbuzz_too -lfreetype_too -lglib-2.0 -lshlwapi -lpcre -lintl -liconv -lcomdlg32 -loleaut32 -limm32 -lopengl32 /mxe/usr/x86_64-w64-mingw32.static/qt5/lib/libQt5Qml.a /mxe/usr/x86_64-w64-mingw32.static/qt5/lib/libQt5Network.a -ldnsapi -liphlpapi -lssl -lcrypto -lgdi32 -lcrypt32 /mxe/usr/x86_64-w64-mingw32.static/qt5/lib/libQt5Core.a -lmpr -lnetapi32 -luserenv -lversion -lws2_32 -lkernel32 -luser32 -lshell32 -luuid -lole32 -ladvapi32 -lwinmm -lz -lpcre2-16  -lopengl32 -lmingw32 /mxe/usr/x86_64-w64-mingw32.static/qt5/lib/libqtmain.a -L/mxe/usr/x86_64-w64-mingw32.static/qt5/lib /mxe/usr/x86_64-w64-mingw32.static/qt5/lib/libQt5Core.a -lmpr -lnetapi32 -luserenv -lversion -lws2_32 -lkernel32 -luser32 -lshell32 -luuid -lole32 -ladvapi32 -lwinmm -lz -lpcre2-16
```