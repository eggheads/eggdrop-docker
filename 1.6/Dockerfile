FROM alpine:3.4 as build
MAINTAINER Geo Van O <geo@eggheads.org>

RUN adduser -S eggdrop

# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2'

RUN apk add --no-cache tcl bash
RUN apk add --no-cache --virtual \
  egg-deps \
  tcl-dev \
  wget \
  make \
  tar \
  gpgme \
  build-base

RUN wget ftp://ftp.eggheads.org/pub/eggdrop/source/1.6/eggdrop1.6.21.tar.gz
RUN wget ftp://ftp.eggheads.org/pub/eggdrop/source/1.6/eggdrop1.6.21.tar.gz.asc
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-key B0B3D92ABE1D20233A2ECB01DB909F5EE7C0E7F7
RUN gpg --batch --verify eggdrop1.6.21.tar.gz.asc eggdrop1.6.21.tar.gz
RUN rm eggdrop1.6.21.tar.gz.asc
RUN tar -zxvf eggdrop1.6.21.tar.gz
RUN rm eggdrop1.6.21.tar.gz

WORKDIR /eggdrop1.6.21
ENV CFLAGS="-std=gnu89"
RUN ./configure --with-tclinc=/usr/include/tcl.h --with-tcllib=/usr/lib/libtcl8.6.so \
    && make config \
    && make \
    && make install DEST=/home/eggdrop/eggdrop

WORKDIR /home/eggdrop/eggdrop
RUN rm -rf eggdrop1.6.21
RUN mkdir /home/eggdrop/eggdrop/data
RUN chown -R eggdrop /home/eggdrop/eggdrop
RUN apk del egg-deps

FROM alpine:3.11
RUN adduser -S eggdrop

ENV NICK=""
ENV SERVER=""
ENV LISTEN="3333"
ENV OWNER=""
ENV USERFILE="eggdrop.user"
ENV CHANFILE="eggdrop.chan"

EXPOSE 3333
RUN apk add --no-cache tcl bash openssl 'su-exec>=0.2'
RUN mkdir /home/eggdrop/eggdrop
COPY --from=build /home/eggdrop/eggdrop/eggdrop* /home/eggdrop/eggdrop/
COPY --from=build /home/eggdrop/eggdrop/data /home/eggdrop/eggdrop/
COPY --from=build /home/eggdrop/eggdrop/modules* /home/eggdrop/eggdrop/

COPY entrypoint.sh /home/eggdrop/eggdrop
COPY docker.tcl /home/eggdrop/eggdrop/scripts/
WORKDIR /home/eggdrop/eggdrop

ENTRYPOINT ["/home/eggdrop/eggdrop/entrypoint.sh"]
CMD ["eggdrop.conf"]