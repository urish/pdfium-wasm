FROM urish/pdfium-wasm

RUN mkdir /build/wrapper

ADD build.sh /build/wrapper/build.sh
ADD src /build/wrapper/src

WORKDIR /build/wrapper
RUN mkdir dist

RUN bash -ic './build.sh'

WORKDIR /build/wrapper/dist
ADD wrapper.js /build/wrapper/src/wrapper.js

CMD bash -ic 'node ../src/wrapper.js'
