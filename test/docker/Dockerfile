FROM alpine:3.7 as base
RUN apk add --no-cache curl bash tree build-base nginx

WORKDIR /usr/src
RUN mkdir -p test/logs /run/nginx
COPY src/bb-import.sh /usr/src/bb-import.sh
COPY src/bb-import.ini /usr/src/bb-import.ini
COPY test/files/* /test/

FROM base
RUN bash ./test/test.sh
