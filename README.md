# pdfium-wasm

PDFium compiled for Web Assembly

## Usage

Currently only usage inside Node.js is supported. Most of the public
PDFium API is available. To install this to your project simply run:

```shell
npm install --save pdfium-wasm
```

Check out the [example project](https://github.com/urish/pdfium-wasm-example) for a simple usage example. 

## Building

Build with docker:

```bash
docker build -t pdfium-wasm .
```

## Building & Running Example

```bash
docker build -t pdfium-example example
docker run pdfium-example
```

This should load [example/src/web-assembly.pdf](example/src/web-assembly.pdf) and print the number
of page. See the [source code](example/src/pagecount.c).
