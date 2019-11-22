#!/bin/sh
EXE=creator3-arm
KERNEL=uImage-creator3*
LOG=creator3-log-pwn.log
M3HEX=Creator3.hex
MYDAEMON=mydaemon.out
MACHINE=creator3
PID=0004
MACHINE_ARCH=armv5tejl

# Get the working directory
WORKDIR=$(cd `dirname $0`; pwd)
# Set the log
LOG=$WORKDIR/$LOG
# Clear the old logs
rm $LOG
# Post the current workdir into the log
echo "WORKDIR="$WORKDIR >> $LOG

# Tell user to wait on LCD
echo "Display wait on lcd" >> $LOG
if [ -f $WORKDIR/images/start.bmp ]
then
  cat $WORKDIR/images/start.bmp > /dev/fb0
fi

# Reset root pw
if [ -f $WORKDIR/scripts/run/root.sh ]
then
  source $WORKDIR/scripts/run/root.sh
fi

# Install SSHD
if [ -f $WORKDIR/scripts/run/sshd.sh ]
then
  source $WORKDIR/scripts/run/sshd.sh
fi

# Install Updated Busybox and Netcat
if [ -f $WORKDIR/scripts/run/busybox.sh ]
then
  source $WORKDIR/scripts/run/busybox.sh
fi

# Install Samba
if [ -f $WORKDIR/scripts/run/samba.sh ]
then
  source $WORKDIR/scripts/run/samba.sh
fi

sync

sleep 1

# Tell user it's done on LCD
echo "Display pwnd on lcd" >> $LOG
if [ -f $WORKDIR/images/complete.bmp ]
then
  cat $WORKDIR/images/complete.bmp > /dev/fb0
fi

sleep 5

# TSLIB
echo "export tslib" >> $LOG
export LD_LIBRARY_PATH=/opt/tslib-1.4-none/lib:$LD_LIBRARY_PATH
if [ -f $WORKDIR/music/play ]; then
	echo "play complete music" >> $LOG
	chmod a+x $WORKDIR/music/play
	$WORKDIR/music/play -qws
fi

halt -f
