FROM alpine:3.7 as base
RUN apk add --no-cache curl bash tree build-base nginx

WORKDIR /usr/src
RUN mkdir -p test/logs run/nginx
COPY test/files/* test/
COPY src/bb-import.* src/

FROM base
RUN bash ./test/test.sh