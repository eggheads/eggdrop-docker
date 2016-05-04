#!/bin/bash

cd /home/eggdrop/eggdrop
if ! [ -z ${FIRSTRUN} ]; then USERFLAG="-m"; fi
if [ -z ${SERVER} ]; then
  echo ""
  echo "--------------------------------------------------"
  echo "You have not set one of the required variables."
  echo "The following variables are must be set via the"
  echo "-e command line argument in order to run"
  echo "eggdrop:"
  echo ""
  echo "NICK   - set IRC nickname"
  echo "SERVER - set IRC server to connect to"
  echo ""
  echo "IF THIS IS THE FIRST TIME running this instance"
  echo "of eggdrop, you will want to add the FIRSTRUN=yes"
  echo "argument as well."
  echo ""
  echo "Example:"
  echo "docker run -ti -e NICK=DockerBot -e SERVER=irc.freenode.net -e FIRSTRUN=yes eggdrop"
  echo ""
  echo "If you wish to telnet or DCC to your bot, you will"
  echo "need to expose the docker port to your host by"
  echo "adding -p 3333:3333 (or whatever port eggdrop is"
  echo "listening on) to your docker run command."
  echo "--------------------------------------------------"
  echo ""
  exit
fi
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
