FROM ubuntu:14.04
MAINTAINER Geo Van O <geo@eggheads.org>

RUN apt-get update && apt-get install -y wget unzip pgpgpg build-essential tcl8.6 tcl8.6-dev git && rm -rf /var/lib/apt/lists/*
RUN useradd -ms /bin/bash eggdrop
USER eggdrop
WORKDIR /home/eggdrop
RUN wget www.geteggdrop.com \
&& wget ftp://ftp.eggheads.org/pub/eggdrop/source/stable/eggdrop1.6.21.tar.gz.asc \
&& gpg --keyserver pgpkeys.mit.edu --recv-key E7C0E7F7 \
&& gpg --batch --verify eggdrop1.6.21.tar.gz.asc \
&& rm eggdrop1.6.21.tar.gz.asc
RUN tar -zxvf eggdrop1.6.21.tar.gz
WORKDIR /home/eggdrop/eggdrop1.6.21
RUN ./configure --with-tclinc=/usr/include/tcl8.6/tcl.h --with-tcllib=/usr/lib/x86_64-linux-gnu/libtcl8.6.so
RUN make config
RUN make
RUN make install
ENV NICK=""
ENV SERVER=""
ENV LISTEN="3333"
ENV OWNER=""
ENV USERFILE="eggdrop.user"
ENV CHANFILE="eggdrop.chan"
ENV CONFIG="eggdrop.conf"
ENV FIRSTRUN=""
WORKDIR /home/eggdrop/eggdrop
ADD entrypoint.sh /home/eggdrop/eggdrop
CMD /home/eggdrop/eggdrop/entrypoint.sh
