#! /bin/sh
# /etc/init.d/container-web
#

# Some things that run always
#touch /var/lock/blah

# Carry out specific functions when asked to by the system
PIDFAYE=$(lsof -i:9292 -t)
echo "$OUTPUT"

case "$1" in
  start)
    echo "Starting script container "
    cd /var/www/icd/
    nohup foreman start >/dev/null &
    ;;
  stop)
    echo "Stopping script container"
    sudo killall rake
    sudo killall rackup 
    echo "Killing faye with pid $PIDFAYE"
    sudo kill "$PIDFAYE"
    ;;
  *)
    echo "Usage: /etc/init.d/blah {start|stop}"
    exit 1
    ;;
esac

exit 0
