FROM alpine:3.20
LABEL org.opencontainers.image.authors="Geo Van O <geo@eggheads.org>" \
      org.opencontainers.image.url="https://www.eggheads.org"

RUN addgroup -S -g 3333 eggdrop \
    && adduser -S -u 3333 eggdrop eggdrop

# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2' bash openssl

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
  && wget ftp://ftp.eggheads.org/pub/eggdrop/source/1.10/eggdrop-1.10.0.tar.gz \
  && wget ftp://ftp.eggheads.org/pub/eggdrop/source/1.10/eggdrop-1.10.0.tar.gz.asc \
  && gpg --keyserver keyserver.ubuntu.com --recv-key E01C240484DE7DBE190FE141E7667DE1D1A39AFF \
  && gpg --batch --verify eggdrop-1.10.0.tar.gz.asc eggdrop-1.10.0.tar.gz \
  && command -v gpgconf > /dev/null \
  && gpgconf --kill all \
  && rm eggdrop-1.10.0.tar.gz.asc \
  && tar -zxvf eggdrop-1.10.0.tar.gz \
  && rm eggdrop-1.10.0.tar.gz \
  && ( cd eggdrop-1.10.0 \
    && ./configure \
    && make config \
    && nproc="$(nproc)" \
    && make -j"$nproc" \
    && make install DEST=/home/eggdrop/eggdrop ) \
  && rm -rf eggdrop-1.10 \
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
