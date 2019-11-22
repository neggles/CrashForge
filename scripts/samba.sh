#
#
# This script will install Samba (Windows file sharing)
# If connecting from Windows 10, you NEED to install SMB 1
# This is in Control Panel > Programs > Windows Features
# Click the checkbox and reboot
# There is NO password for the default
# It loads the /data partition which is the internal SD card
# This is where print files are stored when uploading via FlashPrint
#
# If you want to install your own smb.conf
# Copy smb.conf from backup dir, change it, then put it in the samba dir
# Next time you run CrashForge from the USB stick it will install
#

$WORKDIR = $1
$LOG = $2

echo "------- Installing samba -------" >> $LOG
echo "Copy samba.tar.gz to /opt" >> $LOG
cp $WORKDIR/binaries/samba/samba.tar.gz /opt
echo "Untarring samba into /opt" >> $LOG
cd /opt && /bin/tar -xvf /opt/samba.tar.gz && rm /opt/samba.tar.gz && cd /mnt
echo "Installing samba start script" >> $LOG
cp $WORKDIR/binaries/samba/S91smb /etc/init.d/

# Did the user make their own smb.conf?
if [ -f $WORKDIR/binaries/samba/smb.conf ]; then
  echo "Copying current smb.conf to backup" >> $LOG
  if [ -f $WORKDIR/backup/smb.conf ]
  then
    echo "File exists! Not copying!" >> $LOG
  else
    cp /opt/samba/etc/smb.conf $WORKDIR/backup/
  fi
  echo "Relocating smb.conf to _old for rollback if needed" >> $LOG
  mv /opt/samba/etc/smb.conf /opt/samba/etc/smb.conf_original
  echo "Installing user updated smb.conf" >> $LOG
  cp $WORKDIR/binaries/samba/smb.conf /opt/samba/etc/
fi
