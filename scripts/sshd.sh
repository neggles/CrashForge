#
#
# This script will turn on OpenSSH
#

$WORKDIR = $1
$LOG = $2

echo "------- Installing sshd -------" >> $LOG
echo "Changing perms for sshd" >> $LOG
cp $WORKDIR/binaries/sshd/S50sshd /etc/init.d/
echo "Installing sshd start rc script" >> $LOG
chmod a+x /etc/init.d/S50sshd
echo "Copying current sshd_config to backup" >> $LOG
if [ -f $WORKDIR/backup/sshd_config ]
then
  echo "File exists! Not copying!" >> $LOG
else
  cp /etc/ssh/sshd_config $WORKDIR/backup/
fi
echo "Installing sshd_config" >> $LOG
cp $WORKDIR/binaries/sshd/sshd_config /etc/ssh/
echo "Fixing permissions on /var/empty" >> $LOG
rm -rf /var/empty
mkdir /var/empty
