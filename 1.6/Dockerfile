FROM alpine
MAINTAINER Geo Van O <geo@eggheads.org>

RUN apk update \
&& apk add --no-cache sudo
RUN adduser -S eggdrop
RUN echo "eggdrop ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER eggdrop
WORKDIR /home/eggdrop
RUN sudo -n apk add --no-cache tcl tcl-dev wget make tar gpgme bash build-base \
&& wget ftp://ftp.eggheads.org/pub/eggdrop/source/stable/eggdrop1.6.21.tar.gz \
&& wget ftp://ftp.eggheads.org/pub/eggdrop/source/stable/eggdrop1.6.21.tar.gz.asc \
&& gpg --keyserver ha.pool.sks-keyservers.net --recv-key B0B3D92ABE1D20233A2ECB01DB909F5EE7C0E7F7 \
&& gpg --batch --verify eggdrop1.6.21.tar.gz.asc eggdrop1.6.21.tar.gz \
&& rm eggdrop1.6.21.tar.gz.asc \
&& tar -zxvf eggdrop1.6.21.tar.gz \
&& rm eggdrop1.6.21.tar.gz \
&& cd eggdrop1.6.21 \
&& CFLAGS="-std=gnu89" ./configure --with-tclinc=/usr/include/tcl.h --with-tcllib=/usr/lib/libtcl8.6.so \
&& make config \
&& make \
&& make install \
&& rm -rf eggdrop1.6.21 \
&& sudo -n apk del tcl-dev wget make tar gpgme build-base
RUN sudo -n ash -c 'echo "root ALL=(ALL) ALL" > /etc/sudoers'
ENV NICK=""
ENV SERVER=""
ENV LISTEN="3333"
ENV OWNER=""
ENV USERFILE="eggdrop.user"
ENV CHANFILE="eggdrop.chan"
ENV FIRSTRUN=""
WORKDIR /home/eggdrop/eggdrop
RUN mkdir /home/eggdrop/eggdrop/data
EXPOSE 3333
ADD entrypoint.sh /home/eggdrop/eggdrop
ADD docker.tcl /home/eggdrop/eggdrop/scripts
ENTRYPOINT ["/home/eggdrop/eggdrop/entrypoint.sh"]
CMD ["eggdrop.conf"]
