#!/bin/bash
### BEGIN INIT INFO
#
# Provides:             dump1090
# Required-Start:       $remote_fs
# Required-Stop:        $remote_fs
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    dump1090 initscript


PROG="dump1090"
PROG_PATH="/root/dump1090"
PROG_ARGS=" --net --net-sbs-port 30003"
PIDFILE="/var/run/$PROG.pid"

DELAY=5

start() {
      if [ -e $PIDFILE ]; then
          echo "Error! $PROG is currently running!" 1>&2
          exit 1
      else
          cd $PROG_PATH
          ./$PROG $PROG_ARGS 2>&1 >/dev/null &
          echo "$PROG started, waiting $DELAY seconds..."
          touch $PIDFILE
      fi
}

stop() {
      if [ -e $PIDFILE ]; then
         echo "$PROG is running"
         killall $PROG
         rm -f $PIDFILE
         echo "$PROG stopped"
      else
          echo "Error! $PROG not started!" 1>&2
          exit 1
      fi
}

if [ "$(id -u)" != "0" ]; then
      echo "This script must be run as root" 1>&2
      exit 1
fi

case "$1" in
      start)
          start
          exit 0
      ;;
      stop)
          stop
          exit 0
      ;;
      reload|restart|force-reload)
          stop
          start
          exit 0
      ;;
      **)
          echo "Usage: $0 {start|stop|reload}" 1>&2
          exit 1
      ;;
esac