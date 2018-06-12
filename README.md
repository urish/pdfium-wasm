# pdfium-wasm

Building PDFium for Web Assembly

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
