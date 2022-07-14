## Simple nag script to alert a Docker Eggdrop owner
## that they are not using a mounted host datapoint
## for persistent data storage, and they will 
## likely lose all their data and murder kittens
## at some point.

bind CHON n * nag_owner 

proc nag_owner {hand idx} {
  if [catch {exec mountpoint /home/eggdrop/eggdrop/data}] { 
    putlog "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    putlog "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    putlog "!! OOPS! You did not mount a data volume from the host when"
    putlog "!! you started Eggdrop via Docker. This means your data is"
    putlog "!! not stored anywhere outside this container, and it is"
    putlog "!! possible at some point you will LOSE YOUR EGGDROP DATA!"
    putlog "!!"
    putlog "!! A mounted host data volume also makes it very easy to"
    putlog "!! edit your config file from the host."
    putlog "!!"
    putlog "!! To mount a data volume, simply stop this container and add:"
    putlog "!! -v /path/to/your/saved/data/:/home/eggdrop/eggdrop/data"
    putlog "!! to your 'docker run' command and we'll do the rest!"
    putlog "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    putlog "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  }
}
