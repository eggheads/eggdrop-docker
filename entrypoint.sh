#!/bin/bash
set -e

if [ "$1" = 'eggdrop.conf' ]; then

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
  echo "Example:"
  echo "docker run -ti -e NICK=DockerBot -e SERVER=irc.freenode.net eggdrop"
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
sed -i "/you.need.to.change.this:6667/c\ ${SERVER}" eggdrop.conf
sed -i "/#listen 3333 all/c\listen ${LISTEN} all" eggdrop.conf
sed -i "/#set owner \"MrLame, MrsLame\"/c\set owner \"${OWNER}\"" eggdrop.conf
sed -i "/set userfile \"LamestBot.user\"/c\set userfile ${USERFILE}" eggdrop.conf
sed -i "/set chanfile \"LamestBot.chan\"/c\set chanfile ${CHANFILE}" eggdrop.conf
sed -i '/edit your config file completely like you were told/d' eggdrop.conf
sed -i '/Please make sure you edit your config file completely/d' eggdrop.conf

if ! mountpoint -q /home/eggdrop/eggdrop/data; then
  echo ""
  echo "#####################################################"
  echo "You did not specify a location on the host machine"
  echo "to store your data. This means NOTHING will persist"
  echo "if this docker container is deleted or updated, such"
  echo "as user lists, chan lists, or ban lists."
  echo ""
  echo "In other words, you will likely LOSE YOUR DATA!"
  echo ""
  echo "If you want to continue, type \"bad idea\" at the"
  echo "prompt, otherwise, hit enter and run again, adding:"
  echo "----------------------------------------------------"
  echo "-v /path/to/your/saved/data/:/home/eggdrop/eggdrop/data"
  echo "----------------------------------------------------"
  echo "to your 'docker run' command."
  echo "####################################################"
  echo ""
  echo "Do you want to continue without saved files? [no]:"
  read input
  
  if [ "$input" != "bad idea" ]; then
    exit
  fi
fi

mkdir -p /home/eggdrop/eggdrop/data
if ! [ -a /home/eggdrop/eggdrop/data/eggdrop.conf ]; then
  ln -s /home/eggdrop/eggdrop/data/eggdrop.conf /home/eggdrop/eggdrop/eggdrop.conf
fi
if ! [ -a /home/eggdrop/eggdrop/data/eggdrop.user ]; then
  sed -i "/set userfile ${USERFILE}/c\set userfile data/${USERFILE}" eggdrop.conf
fi
  ln -s /home/eggdrop/eggdrop/data/eggdrop.user /home/eggdrop/eggdrop/eggdrop.user
if ! [ -a /home/eggdrop/eggdrop/data/eggdrop.chan ]; then
  sed -i "/set chanfile ${CHANFILE}/c\set chanfile data/${CHANFILE}" eggdrop.conf
fi
  ln -s /home/eggdrop/eggdrop/data/eggdrop.chan /home/eggdrop/eggdrop/eggdrop.chan

./eggdrop -nt -m $1
fi

exec "$@"
