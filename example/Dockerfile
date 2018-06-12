FROM urish/pdfium-wasm

RUN mkdir /build/example

ADD build.sh /build/example/build.sh
ADD src /build/example/src

WORKDIR /build/example
RUN mkdir dist

RUN bash -ic './build.sh'

WORKDIR /build/example/dist
CMD bash -ic 'node pagecount.js'
