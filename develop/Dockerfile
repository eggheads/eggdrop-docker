FROM alpine:3.23
LABEL org.opencontainers.image.authors="Geo Van O <geo@eggheads.org>" \
      org.opencontainers.image.url="https://www.eggheads.org"

RUN addgroup -S -g 3333 eggdrop \
    && adduser -S -u 3333 eggdrop eggdrop

# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2' bash openssl tcl9 tcl9-dev

ENV EGGDROP_SHA256=fdfc2d08c17f6318b351981a64b193228852bb740ad94d2b43d3cd5585067c4b
ENV EGGDROP_COMMIT=d93dbd7444d2519b83f613fe4d21e36ae4cc5797

RUN apk add --no-cache --virtual egg-deps wget ca-certificates make tar gnupg build-base openssl-dev bsd-compat-headers zlib-dev \
  && wget "https://github.com/eggheads/eggdrop/archive/$EGGDROP_COMMIT.tar.gz" -O develop.tar.gz \
  && echo "$EGGDROP_SHA256 *develop.tar.gz" | sha256sum -c - \
  && tar -zxf develop.tar.gz \
  && rm develop.tar.gz \
    && ( cd eggdrop-$EGGDROP_COMMIT \
    && ./configure \
    && make config \
    && nproc="$(nproc)" \
    && make -j"$nproc" \
    && make install DEST=/home/eggdrop/eggdrop ) \
  && rm -rf eggdrop-$EGGDROP_COMMIT \
  && mkdir /home/eggdrop/eggdrop/data \
  && chown -R eggdrop /home/eggdrop/eggdrop \
  && apk del --no-network egg-deps

ENV NICK=""
ENV SERVER=""
ENV LISTEN="3333"
ENV USERFILE="eggdrop.user"
ENV CHANFILE="eggdrop.chan"

WORKDIR /home/eggdrop/eggdrop
EXPOSE 3333
COPY entrypoint.sh ./
COPY docker.tcl ./scripts/

ENTRYPOINT ["/home/eggdrop/eggdrop/entrypoint.sh"]
CMD ["eggdrop.conf"]
