FROM alpine
MAINTAINER Geo Van O <geo@eggheads.org>

ENV EGGDROP_SHA256 c176534407642f841f81b3609402c7d61dd1999c72f3b679df3f63b14b29bb8c
RUN apk update \
&& apk add --no-cache sudo
RUN adduser -S eggdrop
RUN echo "eggdrop ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER eggdrop
WORKDIR /home/eggdrop
RUN sudo -n apk add --no-cache tcl tcl-dev wget tar make gpgme bash build-base \
&& wget --no-check-certificate https://github.com/eggheads/eggdrop/archive/develop.tar.gz && echo "$EGGDROP_SHA256  develop.tar.gz" | sha256sum -c - \
&& tar -zxvf develop.tar.gz \
&& rm develop.tar.gz \
&& cd /home/eggdrop/eggdrop-develop \
&& ./configure --with-tclinc=/usr/include/tcl8.6/tcl.h --with-tcllib=/usr/lib/x86_64-linux-gnu/libtcl8.6.so \
&& make config \
&& make \
&& make install \
&& rm -rf eggdrop-develop \
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
