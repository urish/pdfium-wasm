# PDFium + Emscripten build environment
# Copyright (C) 2018, Uri Shaked. Published under the MIT license.

FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y wget python git cmake xz-utils lsb-release sudo

## Install EMScripten SDK

WORKDIR /opt

RUN wget https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz
RUN tar zxf emsdk-portable.tar.gz

WORKDIR /opt/emsdk-portable

RUN ./emsdk update
RUN ./emsdk install latest
RUN ./emsdk activate latest

RUN echo "source $(pwd)/emsdk_env.sh" >> ~/.bashrc

### Install Google Depot Tools

RUN cd /opt && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
ENV PATH="/opt/depot_tools:${PATH}"

### Check out PDFium Source code

RUN mkdir /build
WORKDIR /build
RUN gclient config --unmanaged https://pdfium.googlesource.com/pdfium.git
RUN gclient sync

### Install build dependencies for PDFium

WORKDIR /build/pdfium
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install tzdata
RUN echo n | ./build/install-build-deps.sh

### Apply patches

COPY config/build.config /build/pdfium/out/Debug/args.gn

COPY patches/pdfium.diff /build/pdfium/pdfium.diff
RUN patch -i pdfium.diff -p1

COPY patches/build.diff /build/pdfium/build/build.diff
RUN patch -d build -i build.diff -p1

RUN gn gen out/Debug

RUN cp /usr/include/jpeglib.h /usr/include/jmorecfg.h /usr/include/zlib.h /usr/include/zconf.h /usr/include/x86_64-linux-gnu/jconfig.h .
RUN mkdir linux
RUN cp /usr/include/linux/limits.h linux/limits.h

### Build it!

RUN bash -c 'source /opt/emsdk-portable/emsdk_env.sh && ninja -C out/Debug pdfium'

## Cache system libraries
RUN bash -c 'echo "int main() { return 0; }" > /tmp/main.cc'
RUN bash -c 'source /opt/emsdk-portable/emsdk_env.sh && em++ -o /tmp/main.html /tmp/main.cc'

## Build pdfium-wasm.js

RUN apt-get install -y doxygen
WORKDIR /build/pdfium/public
COPY config/Doxyfile Doxyfile
RUN doxygen

ADD utils utils
RUN bash -ic 'cd utils && npm install'
ENV OBJ_DIR=/build/pdfium/out/Debug/obj
RUN bash -ic 'utils/build-pdfium-wasm.sh'
