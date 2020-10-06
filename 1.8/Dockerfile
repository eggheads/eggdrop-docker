FROM alpine:3.11
MAINTAINER Geo Van O <geo@eggheads.org>

RUN adduser -S eggdrop

# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2'

RUN apk add --no-cache tcl bash openssl
RUN apk add --no-cache --virtual \
  egg-deps \
  tcl-dev \
  wget \
  ca-certificates \
  make \
  tar \
  gpgme \
  build-base \
  openssl-dev

WORKDIR /
RUN wget ftp://ftp.eggheads.org/pub/eggdrop/source/1.8/eggdrop-1.8.4.tar.gz
RUN wget ftp://ftp.eggheads.org/pub/eggdrop/source/1.8/eggdrop-1.8.4.tar.gz.asc
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-key E01C240484DE7DBE190FE141E7667DE1D1A39AFF
RUN gpg --batch --verify eggdrop-1.8.4.tar.gz.asc eggdrop-1.8.4.tar.gz
RUN command -v gpgconf > /dev/null
RUN gpgconf --kill all
RUN tar -zxvf eggdrop-1.8.4.tar.gz
RUN rm eggdrop-1.8.4.tar.gz

WORKDIR /eggdrop-1.8.4
RUN ./configure
RUN make config
RUN make
RUN make install DEST=/home/eggdrop/eggdrop

WORKDIR /home/eggdrop/eggdrop
RUN rm -rf /eggdrop-1.8.4
RUN mkdir /home/eggdrop/eggdrop/data
RUN chown -R eggdrop /home/eggdrop/eggdrop
RUN apk del egg-deps

ENV NICK=""
ENV SERVER=""
ENV LISTEN="3333"
ENV OWNER=""
ENV USERFILE="eggdrop.user"
ENV CHANFILE="eggdrop.chan"

EXPOSE 3333
COPY entrypoint.sh /home/eggdrop/eggdrop
COPY docker.tcl /home/eggdrop/eggdrop/scripts/

ENTRYPOINT ["/home/eggdrop/eggdrop/entrypoint.sh"]
CMD ["eggdrop.conf"]
