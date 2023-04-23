FROM alpine:3.7 as base
RUN apk add --no-cache curl bash tree build-base nginx doas; adduser ragdata -G wheel; echo "ragdata:123" | chpasswd; echo 'permit :wheel as root' > /etc/doas.d/doas.conf

USER ragdata

WORKDIR /usr/src
RUN mkdir -p test/files/logs /run/nginx
COPY . .

FROM base
RUN bash ./test/files/test.sh
