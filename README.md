# Go QML Bindings

## Pre-Alpha

Please note that this project is in pre-alpha phase. Documentation is missing and some bugs need to be fixed. Right now, we do not recommend anyone to use anything you find here ;)

## Install

```
go get -u github.com/desertbit/gml/cmd/gml
```

## Samples

See the **[GML Samples Repo](https://github.com/desertbit/gml-samples)**.

## Docker Build Containers

The docker image url is: `desertbit/gml`
**[DockerHub Link](https://hub.docker.com/r/desertbit/gml)**

| Image Tag         | Host OS      | Target OS      | Qt Link Type | Note                  |
|:------------------|:-------------|:---------------|:-------------|-----------------------|
| linux             | Linux x86_64 | Linux x86_64   | dynamic      |                       |
| windows_32_shared | Linux x86_64 | Windows i686   | dynamic      |                       |
| windows_64_shared | Linux x86_64 | Windows x86_64 | dynamic      |                       |
| android           | Linux x86_64 | Android        | -            | Not usable - See TODO |

## Build Tags

- static: run pkg-config with the static flag. Required for static Qt builds.

## Debugging

To debug windows problems, use the [MSYS2](https://www.msys2.org/) console.
