#!/bin/bash

cd /home/eggdrop/eggdrop
if ! [ -z ${FIRSTRUN} ]; then USERFLAG="-m"; fi
sed -i "/set nick \"Lamestbot\"/c\set nick \"$NICK\"" eggdrop.conf
sed -i "/another.example.com:7000:password/d" eggdrop.conf
sed -i "/you.need.to.change.this:6667/c\ \"${SERVER}\"" eggdrop.conf
sed -i "/#listen 3333 all/c\listen ${LISTEN} all" eggdrop.conf
sed -i "/#set owner \"MrLame, MrsLame\"/c\set owner \"${OWNER}\"" eggdrop.conf
sed -i "/set userfile \"LamestBot.user\"/c\set userfile \"${USERFILE}\"" eggdrop.conf
sed -i "/set chanfile \"LamestBot.chan\"/c\set chanfile \"${CHANFILE}\"" eggdrop.conf
sed -i '/edit your config file completely like you were told/d' eggdrop.conf
sed -i '/Please make sure you edit your config file completely/d' eggdrop.conf
./eggdrop -n ${USERFLAG} ${CONFIG}
