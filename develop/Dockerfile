FROM alpine:3.11 as builder
MAINTAINER Geo Van O <geo@eggheads.org>

ENV EGGDROP_SHA256 f977f8f586d1b65d2bae581b5b5828d79193a29a217f617c4c74d1868a566c7f
ENV EGGDROP_COMMIT 886c2ff6f943952018000c16cb48c08b8ab99127

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
  && apk del egg-deps

FROM alpine:3.11 as runtime
COPY --from=builder /home/eggdrop/eggdrop /home/eggdrop/eggdrop
RUN adduser -S eggdrop \
  && apk --update add --no-cache tcl bash openssl \
  # grab su-exec for easy step-down from root
  'su-exec>=0.2' \
  && mkdir /home/eggdrop/eggdrop/data \
  && chown -R eggdrop /home/eggdrop/eggdrop
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
