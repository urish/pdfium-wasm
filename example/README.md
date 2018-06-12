## Pagecount example for PDFium-wasm

## Building the example

```bash
docker build -t pdfium-example .
```

## Running the example

```bash
docker run pdfium-example
```

The [example program](src/pagecount.c) loads [src/web-assembly.pdf](src/web-assembly.pdf) and prints out the number of pages in the document. It serves as an "Hello World" example for working with the PDFium API.
