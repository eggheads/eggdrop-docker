FROM alpine:3.11 as build
MAINTAINER Geo Van O <geo@eggheads.org>

RUN adduser -S eggdrop

# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2'

ENV EGGDROP_SHA256 b34d8702f2429882c15f80274c146a5f2859326811eb9b2d272174a10bc521dd
ENV EGGDROP_COMMIT 9711e38ef62ae4d4269a803f7bd41480f61e044c

RUN apk --update add --no-cache tcl bash openssl
RUN apk --update add --no-cache --virtual \
  egg-deps \
  tcl-dev \
  wget \
  ca-certificates \
  make \
  tar \
  gpgme \
  build-base \
  openssl-dev

RUN wget "https://github.com/eggheads/eggdrop/archive/$EGGDROP_COMMIT.tar.gz" -O develop.tar.gz
RUN echo "$EGGDROP_SHA256  develop.tar.gz" | sha256sum -c -
RUN tar -zxvf develop.tar.gz
RUN rm develop.tar.gz
WORKDIR /eggdrop-$EGGDROP_COMMIT
RUN ./configure \
    && make config \
    && make \
    && make install DEST=/home/eggdrop/eggdrop

WORKDIR /home/eggdrop/eggdrop
RUN rm -rf eggdrop-$EGGDROP_COMMIT
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
COPY --from=build /home/eggdrop/eggdrop /home/eggdrop/eggdrop

COPY entrypoint.sh /home/eggdrop/eggdrop
COPY docker.tcl /home/eggdrop/eggdrop/scripts/
WORKDIR /home/eggdrop/eggdrop
ENTRYPOINT ["/home/eggdrop/eggdrop/entrypoint.sh"]
CMD ["eggdrop.conf"]