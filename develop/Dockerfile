FROM alpine:3.7
MAINTAINER Geo Van O <geo@eggheads.org>

RUN adduser -S eggdrop

# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2'

ENV EGGDROP_SHA256 5a7ec41eebc415065256946d7a986012a493ec483930c9de3c5d84916e236366
ENV EGGDROP_COMMIT 24fad2705e619751d86061d1031e3c60b9b2e6da

RUN apk --update add --no-cache tcl bash openssl
RUN apk --update add --no-cache --virtual egg-deps tcl-dev wget ca-certificates make tar gpgme build-base openssl-dev \
  && wget "https://github.com/eggheads/eggdrop/archive/$EGGDROP_COMMIT.tar.gz" -O develop.tar.gz \
  && echo "$EGGDROP_SHA256  develop.tar.gz" | sha256sum -c - \
  && tar -zxvf develop.tar.gz \
  && rm develop.tar.gz \
    && ( cd eggdrop-$EGGDROP_COMMIT \
    && ./configure \
    && make config \
    && make \
    && make install DEST=/home/eggdrop/eggdrop ) \
  && rm -rf eggdrop-$EGGDROP_COMMIT \
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
