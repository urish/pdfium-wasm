FROM urish/pdfium-wasm

WORKDIR /build/pdfium/out/dist
ADD src /build/wrapper/src

CMD bash -ic 'node /build/wrapper/src/wrapper.js /build/wrapper/src/web-assembly.pdf'
