FROM alpine:3.20
LABEL org.opencontainers.image.authors="Geo Van O <geo@eggheads.org>" \
      org.opencontainers.image.url="https://www.eggheads.org"

RUN addgroup -S -g 3333 eggdrop \
    && adduser -S -u 3333 eggdrop eggdrop

# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2' bash openssl

ENV EGGDROP_SHA256=d185512ad282aeee49a75328e847f604c762e94be19fb1e01a7e8a4f927730b8
ENV EGGDROP_COMMIT=f80f8ae468fd7bcec83407134ef5941225131104

RUN apk add --no-cache --virtual egg-deps wget ca-certificates make tar gnupg build-base openssl-dev \
  && wget "https://prdownloads.sourceforge.net/tcl/tcl8.6.13-src.tar.gz" -O tcl8.6.13-src.tar.gz --progress=dot:giga \
  && tar -zxf tcl8.6.13-src.tar.gz \
  && ( cd tcl8.6.13 \
# Fix Tcl UTF Emoji support
    && sed -i "/define TCL_UTF_MAX/c\#define TCL_UTF_MAX 6" generic/tcl.h \
    && cd unix \
    && ./configure \
    && nproc="$(nproc)" \
    && make -j"$nproc" \
    && make install ) \
  && rm -rf tcl8.6.13-src.tar.gz \
  && rm -rf tcl8.6.13 \
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
