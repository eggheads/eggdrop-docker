FROM ubuntu:14.04
MAINTAINER Geo Van O <geo@eggheads.org>

ENV EGGDROP_SHA256 642bd36eb641f9f63c7d5d41578bd78de58a8d5af5decf59dd9725448b9c2d8e
RUN apt-get update && apt-get install -y wget unzip pgpgpg build-essential tcl8.6 tcl8.6-dev git && rm -rf /var/lib/apt/lists/*
RUN useradd -ms /bin/bash eggdrop
USER eggdrop
WORKDIR /home/eggdrop
RUN wget https://github.com/eggheads/eggdrop/archive/develop.tar.gz && echo "$EGGDROP_SHA256 develop.tar.gz" | sha256sum -c -
RUN tar -zxvf develop.tar.gz
WORKDIR /home/eggdrop/eggdrop-develop
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
ENV FIRSTRUN=""
WORKDIR /home/eggdrop/eggdrop
RUN mkdir /home/eggdrop/eggdrop/data
EXPOSE 3333
ADD entrypoint.sh /home/eggdrop/eggdrop
ENTRYPOINT ["/home/eggdrop/eggdrop/entrypoint.sh"]
CMD ["eggdrop.conf"]
