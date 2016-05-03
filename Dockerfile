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
ENV NICK="SuckBot"
ENV SERVER="irc.undernet.org"
ENV LISTEN="3333"
ENV OWNER="SuckDude"
ENV USERFILE="suckbot.user"
ENV CHANFILE="suckbot.chan"
ENV CONFIG="eggdrop.conf"
ENV FIRSTUN=""
WORKDIR /home/eggdrop/eggdrop
ADD entrypoint.sh /home/eggdrop/eggdrop
#RUN if ! [ -z ${FIRSTRUN} ]; then USERFLAG="-m"; fi
#RUN sed -i "/set nick \"Lamestbot\"/c\set nick \"$NICK\"" eggdrop.conf
#RUN sed -i "/another.example.com:7000:password/d" eggdrop.conf
#RUN sed -i "/you.need.to.change.this:6667/c\ \"${SERVER}\"" eggdrop.conf
#RUN sed -i "/#listen 3333 all/c\listen ${LISTEN} all" eggdrop.conf
#RUN sed -i "/#set owner \"MrLame, MrsLame\"/c\set owner \"${OWNER}\"" eggdrop.conf
#RUN sed -i "/set userfile \"LamestBot.user\"/c\set userfile \"${USERFILE}\"" eggdrop.conf
#RUN sed -i "/set chanfile \"LamestBot.chan\"/c\set chanfile \"${CHANFILE}\"" eggdrop.conf
#RUN sed -i '/edit your config file completely like you were told/d' eggdrop.conf
#RUN sed -i '/Please make sure you edit your config file completely/d' eggdrop.conf
#CMD ./eggdrop -n ${USERFLAG} ${CONFIG}
CMD /home/eggdrop/eggdrop/entrypoint.sh
