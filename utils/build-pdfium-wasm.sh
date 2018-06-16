#!/bin/sh

OBJ_DIR="/build/pdfium/out/Debug/obj" 
OUTPUT_DIR="/build/pdfium/out/dist"

mkdir -p $OUTPUT_DIR
emcc -o "$OUTPUT_DIR/pdfium.html" -s EXPORTED_FUNCTIONS="$(node utils/function-names xml/index.xml createDocFromBuffer)" -s EXTRA_EXPORTED_RUNTIME_METHODS='["ccall", "cwrap"]' utils/avail.c @utils/pdfium.rsp -Os
