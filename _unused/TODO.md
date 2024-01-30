# TODO
- Implement hot reloading

## Go
- remove the app completly.

## Code Gen
- use the direct type instead of interface{} -> properties don't return a QVariant.
- test variant as return type and in functions
- test a qmodel as properties
- package names must be unique if code generation is applied to that package. Fix this or prevent this as compiler check.
- test code generation for keep alives 

## C++ Binding
- add qml support for int64
- don't use C.CString instead use the direct byte buffer? (UTF-8 encoding?)
- use everyhwere constData instead of data (strings).

## Docker
- deploy-dlls.sh adds common required Qt plugins. This should be configurable instead?
- Finish the windows static build containers. See the TODO in the docker folder.
- Finish the Android docker containers.

- vor dem bauen committen und taggen, damit das bauen funktioniert
- erst windows bauen und hochladen, bevor 32/64_shared 