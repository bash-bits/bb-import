FROM alpine:3.7 as base
RUN apk add --no-cache curl bash tree build-base nginx

ARG USERNAME=ragdata
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME && useradd -uid $USER_UID --gid $USER_GID -m $USERNAME && apt update && apt install sudo -y && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

WORKDIR /usr/src
RUN mkdir -p test/files/logs /run/nginx
COPY . .

FROM base
RUN bash ./test/files/test.sh
