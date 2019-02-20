# TODO
- Create tests and check with vargrant for memory correctness.

## Go
- remove the app completly.

## QML - Go Bridge
- check, if msgpack can be used with [this](https://github.com/msgpack/msgpack-javascript) javascript lib

## Code Gen
- use the direct type instead of interface{} -> properties don't return a QVariant.
- test variant as return type and in functions
- test a qmodel as properties
- package names must be unique if code generation is applied to that package. Fix this or prevent this as compiler check.
- test code generation for keep alives 

## C++ Binding
- add qml support for int64
- don't use C.CString instead use the direct byte buffer? (UTF-8 encoding?)
- use everythwere constData instead of data (strings).

## Docker
- deploy-dlls.sh adds common required Qt plugins. This should be configurable instead?
- Finish the windows static build containers. See the TODO in the docker folder.
- Finish the Android docker containers.
