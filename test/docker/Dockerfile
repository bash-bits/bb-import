FROM alpine:3.7 as base
RUN apk add --no-cache curl bash tree build-base nginx

WORKDIR /usr/src
RUN mkdir -p test/files/logs /run/nginx
COPY . .

FROM base
RUN bash ./test/files/test.sh
