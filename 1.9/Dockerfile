FROM alpine:3.16
MAINTAINER Geo Van O <geo@eggheads.org>

RUN adduser -S eggdrop

# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2'

RUN apk add --no-cache tcl bash openssl
RUN apk add --no-cache --virtual egg-deps wget ca-certificates make tar gnupg build-base openssl-dev \
  && wget "https://prdownloads.sourceforge.net/tcl/tcl8.6.12-src.tar.gz" -O tcl8.6.12-src.tar.gz \
  && tar -zxf tcl8.6.12-src.tar.gz \
  && ( cd tcl8.6.12 \
# Fix Tcl UTF Emoji support
    && sed -i "/define TCL_UTF_MAX/c\#define TCL_UTF_MAX 6" generic/tcl.h \
    && cd unix \
    && ./configure \
    && make \
    && make install ) \
  && wget ftp://ftp.eggheads.org/pub/eggdrop/source/1.9/eggdrop-1.9.4.tar.gz \
  && wget ftp://ftp.eggheads.org/pub/eggdrop/source/1.9/eggdrop-1.9.4.tar.gz.asc \
  && gpg --keyserver keyserver.ubuntu.com --recv-key E01C240484DE7DBE190FE141E7667DE1D1A39AFF \
  && gpg --batch --verify eggdrop-1.9.4.tar.gz.asc eggdrop-1.9.4.tar.gz \
  && command -v gpgconf > /dev/null \
  && gpgconf --kill all \
  && rm eggdrop-1.9.4.tar.gz.asc \
  && tar -zxvf eggdrop-1.9.4.tar.gz \
  && rm eggdrop-1.9.4.tar.gz \
  && ( cd eggdrop-1.9.4 \
    && ./configure \
    && make config \
    && make \
    && make install DEST=/home/eggdrop/eggdrop ) \
  && rm -rf eggdrop-1.9.4 \
  && mkdir /home/eggdrop/eggdrop/data \
  && chown -R eggdrop /home/eggdrop/eggdrop \
  && apk del egg-deps

ENV NICK=""
ENV SERVER=""
ENV LISTEN="3333"
ENV OWNER=""
ENV USERFILE="eggdrop.user"
ENV CHANFILE="eggdrop.chan"

WORKDIR /home/eggdrop/eggdrop
EXPOSE 3333
COPY entrypoint.sh /home/eggdrop/eggdrop
COPY docker.tcl /home/eggdrop/eggdrop/scripts/

ENTRYPOINT ["/home/eggdrop/eggdrop/entrypoint.sh"]
CMD ["eggdrop.conf"]
