FROM ubuntu:14.04
MAINTAINER Geo Van O <geo@eggheads.org>

RUN apt-get update \
&& apt-get install -y wget pgpgpg build-essential tcl8.6 tcl8.6-dev \
&& rm -rf /var/lib/apt/lists/*
RUN useradd -ms /bin/bash eggdrop
USER eggdrop
WORKDIR /home/eggdrop
RUN wget ftp://ftp.eggheads.org/pub/eggdrop/source/stable/eggdrop1.6.21.tar.gz \
&& wget ftp://ftp.eggheads.org/pub/eggdrop/source/stable/eggdrop1.6.21.tar.gz.asc \
&& gpg --keyserver ha.pool.sks-keyservers.net --recv-key B0B3D92ABE1D20233A2ECB01DB909F5EE7C0E7F7 \
&& gpg --batch --verify eggdrop1.6.21.tar.gz.asc eggdrop1.6.21.tar.gz \
&& rm eggdrop1.6.21.tar.gz.asc \
&& tar -zxvf eggdrop1.6.21.tar.gz \
&& cd eggdrop1.6.21 \
&& ./configure --with-tclinc=/usr/include/tcl8.6/tcl.h --with-tcllib=/usr/lib/x86_64-linux-gnu/libtcl8.6.so \
&& make config \
&& make \
&& make install \
&& rm -rf eggdrop1.6.21
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
ENTRYPOINT ["/home/eggdrop/eggdrop/entrypoint.sh"]
CMD ["eggdrop.conf"]
