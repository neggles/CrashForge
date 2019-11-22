#
#
# This script will update busybox for all modules, including netcat
#

$WORKDIR = $1
$LOG = $2

echo "------- Installing busybox -------" >> $LOG
echo "Backing up busybox" >> $LOG
if [ -f $WORKDIR/backup/busybox ]
then
  echo "File exists! Not copying!" >> $LOG
else
  cp /bin/busybox $WORKDIR/backup
fi
echo "Copying current /bin/busybox to /bin/busybox_old" >> $LOG
cp /bin/busybox /bin/busybox_old
echo "Copying new busybox to /bin" >> $LOG
cp $WORKDIR/binaries/busybox/busybox /bin/
echo "Updating permissions to make 100% sure it's executable" >> $LOG
chmod a+x /bin/busybox
echo "Linking netcat to busybox" >> $LOG
ln -s /bin/busybox /usr/bin/nc
