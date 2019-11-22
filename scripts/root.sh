#
#
# This script will reset the root password to 123456
# 123456 is the default Flashforge uses for development
#
#

$WORKDIR = $1
$LOG = $2

echo "------- Updating root password to Flashforge default 123456 -------" >> $LOG
echo "Copying current shadow to backup" >> $LOG
if [ -f $WORKDIR/backup/shadow ]
then
  echo "File exists! Not copying!" >> $LOG
else
  cp /etc/shadow $WORKDIR/backup/
fi
echo "Copying current shadow to for rollback if needed" >> $LOG
cp /etc/shadow /etc/shadow_old
echo "Copying old 123456 password shadow to current" >> $LOG
mv /etc/shadow- /etc/shadow
