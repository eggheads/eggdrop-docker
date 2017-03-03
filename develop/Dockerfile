FROM alpine:3.5
MAINTAINER Geo Van O <geo@eggheads.org>

RUN adduser -S eggdrop

# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2'

ENV EGGDROP_SHA256 17ce77233894c8f2bb26a1c9a7b054e86d57475fcfbcd90b0d200d2a52b9c5eb
ENV EGGDROP_COMMIT f0863681d5e9cb900d1ee4bb1ea7a6bbb36c3b4c

RUN apk add --no-cache tcl tcl-dev wget ca-certificates make tar gpgme bash build-base openssl openssl-dev\
  && wget https://github.com/eggheads/eggdrop/archive/$EGGDROP_COMMIT.tar.gz -O develop.tar.gz\
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
  && apk del tcl-dev wget ca-certificates make tar gpgme build-base openssl-dev

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
