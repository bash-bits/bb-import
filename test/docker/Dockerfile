FROM alpine:3.7 as base
RUN apk add --no-cache curl bash tree build-base nginx useradd -ms /bin/bash ragdata

USER ragdata
WORKDIR /home/ragdata

ARG url="bb-import"
ARG ini="bb-import.ini"

ARG cacheDir="/home/ragdata/.bb"
ARG cache="/home/ragdata/.bb/bb-import.sh"
ARG cfgDir="$cache/cfg"
ARG cfgPath="$cfgDir/$ini"
ARG cachePath="$cache/links/bb-import"
ARG linkDir="$cache/links"

RUN mkdir -p "$cfgDir" "$linkDir" "$cache/data" "$cache/locations"

ARG tmpFile="$cachePath.tmp"
ARG locFile="$cache/locations/$url"

COPY src/bb-import.sh /usr/local/bin/bb-import
RUN chmod +x /usr/local/bin/bb-import

RUN echo "$location" > "$locFile"

COPY src/bb-import.ini /home/ragdata/.bb/bb-import.sh/cfg/bb-import.ini

ARG hash="$(sha1sum < "$tmpFile" | { read -r first rest; echo "$first"; })"
ARG hashFile="$cache/data/$hash"

RUN mv "$tmpFile" "$hashFile"

RUN cd "$linkDir"
RUN ln -fs ../data/"$hash" "$cachePath"

FROM base
RUN bash ./test/test.sh
