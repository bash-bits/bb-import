FROM alpine:3.7 as base
RUN apk add --no-cache curl bash tree build-base nginx

RUN mkdir -p test/logs run/nginx
COPY . .

FROM base
RUN bash ./test/files/test.sh