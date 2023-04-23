FROM alpine:3.7 as base
RUN apk add --no-cache curl bash tree build-base nginx

#RUN adduser -g "ragdata" ragdata && adduser ragdata wheel && apk add doas && echo "permit persist :wheel" >> /etc/doas.d/doas.conf

RUN apk add sudo && NEWUSER="ragdata" && adduser -g "${NEWUSER}" $NEWUSER -D && echo "$NEWUSER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$NEWUSER && chmod 0440 /etc/sudoers.d/$NEWUSER

USER ragdata

WORKDIR /usr/src
RUN sudo mkdir -p test/files/logs /run/nginx
COPY . .

FROM base
RUN bash ./test/files/test.sh
