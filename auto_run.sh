#!/bin/sh

EXE=creator3-arm
UNVS=universal-arm
PID=000C
QTAPP="/opt/flashforge/exe/creator3"
OLD_QTAPP=${QTAPP}"-arm"
#ifconfig eth0 10.33.23.146
udhcpc -i eth0 &
#RUNPARA=" 1 debug -qws "
RUNPARA=" 1 -qws "

for i in 1 2 3 4 5;
do
  if [ $i == 5 ]; then
	mount -t vfat -o,codepage=936,iocharset=utf8 /dev/sda /mnt
	  if [ $? -ne 0 ]; then
			echo "mount /dev/sda to /mnt failed"
			continue
	  else
		ls -al /etc > /mnt/out.etc.log
		if [ -f /mnt/$PID ] || [ -f /mnt/$UNVS ]; then
			if [ -f /mnt/flashforge_init.sh ]; then
				 echo "found /mnt/flashforge_init.sh"
				 chmod a+x /mnt/flashforge_init.sh
				 /mnt/flashforge_init.sh
				 umount /mnt
				 break
			fi
			umount /mnt
		fi
		umount /mnt
	  fi
  else
	  if [ ! -e /dev/sda$i ]; then
		 echo "sda$i not exist"
		 continue
	  fi
	  mount -t vfat -o,codepage=936,iocharset=utf8 /dev/sda$i /mnt
	  if [ $? -ne 0 ]; then
			echo "mount /dev/sda$i to /mnt failed"
			continue
	  else
	  ls -1t /mnt/creator3*.zip
		if [ $? -eq 0 ];then
			UPDATEFILE=`ls -1t /mnt/creator3*.zip | head -n 1`
			if [ -f $UPDATEFILE ];then
				echo "find update file: ${UPDATEFILE}"
				rm -rf /data/update
				cp -a ${UPDATEFILE} /data/
				if [ $? -ne 0 ];then
					rm -rf /data/creator3*.zip
					sync
					umount /mnt
					break
				fi
				sync
				mkdir -p /data/update
				sync
				SRCFILE="/data/`basename ${UPDATEFILE}`"
				if [ -f ${SRCFILE} ];then
					unzip -o ${SRCFILE} -d /data/update/
					sync
					rm -rf ${SRCFILE}
					if [ -f /data/update/$PID ] || [ -f /data/update/$UNVS ]; then
						echo "found /mnt/flashforge_init.sh"
						chmod a+x /data/update/flashforge_init.sh
						/data/update/flashforge_init.sh
						if [ $? -eq 0 ];then
							echo "update failed"
							umount /mnt
							rm -rf /data/update
							sleep 10
						fi
						umount /mnt
						rm -rf /data/update
						break
					fi
				fi
			fi
		fi
		if [ -f /mnt/$PID ] || [ -f /mnt/$UNVS ]; then
			if [ -f /mnt/flashforge_init.sh ]; then
				 echo "found /mnt/flashforge_init.sh"
				 chmod a+x /mnt/flashforge_init.sh
				 /mnt/flashforge_init.sh
				 umount /mnt
				 break
			fi
			umount /mnt
		fi
		umount /mnt
	  fi
  fi
done

echo "Gpio WiFi Power On"
echo 258 >/sys/class/gpio/export
echo out >/sys/class/gpio/gpio258/direction
echo 1 > /sys/class/gpio/gpio258/value
echo 0 > /sys/class/gpio/gpio258/value

echo 259 >/sys/class/gpio/export
echo out >/sys/class/gpio/gpio259/direction
echo 1 > /sys/class/gpio/gpio259/value

ifconfig wlan0 up
wpa_supplicant -d -Dwext -i wlan0 -c /etc/wpa_supplicant.conf -B
sleep 0.1

ifconfig wlan0 | grep wlan0 | grep HWaddr |tr -s ' '| cut -d ' ' -f5 > /opt/WiFiMAC
sync

killall wpa_supplicant
killall wpa_cli

if [ ! "`mount | grep "mmcblk0p3"`" ]; then
	echo "mmcblk0p3 not mounted and will fsck";
	fsck -y /dev/mmcblk0p3 && mount /dev/mmcblk0p3 /data;
fi

WORK_DIR=/opt

rm -rf /data/pics
mkdir /data/pics
rm -rf /data/update/*

export PATH=/opt/curl/bin:$PATH
export LD_LIBRARY_PATH=/opt/curl/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/arm-jsoncpp/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/mjpg-streamer/lib:$LD_LIBRARY_PATH
#/opt/mjpg-streamer/bin/mjpg_streamer -i "input_uvc.so -r 1280x1024 -f 30" -o "output_file.so -f /data/pics -d 15000" -o "output_http.so -w /opt/mjpg-streamer/www" &

export PATH=$WORK_DIR/bin:$PATH
export PATH=$WORK_DIR/flashforge:$PATH

#echo "export libiconv"
#export LD_LIBRARY_PATH=$WORK_DIR/libiconv-1.14-none/lib:$LD_LIBRARY_PATH

# OPENSSL
echo "export openssl"
export OPENSSL_DIR=$WORK_DIR/openssl-1.0.2d-none
export LD_LIBRARY_PATH=$OPENSSL_DIR/lib:$LD_LIBRARY_PATH

# TSLIB
echo "export tslib"
export TSLIBDIR=$WORK_DIR/tslib-1.4-none
export TSLIB_TSEVENTTYPE=INPUT
export TSLIB_CONSOLEDEVICE=none
export TSLIB_FBDEVICE=/dev/fb0
export TSLIB_TSDEVICE=/dev/input/event0
export TSLIB_CALIBFILE=$TSLIBDIR/etc/pointercal
export TSLIB_CONFFILE=$TSLIBDIR/etc/ts.conf
export TSLIB_PLUGINDIR=$TSLIBDIR/lib/ts
export QWS_MOUSE_PROTO="TSLIB:/dev/input/event0"
export PATH=$TSLIBDIR/bin:$PATH
export LD_LIBRARY_PATH=$TSLIBDIR/lib:$LD_LIBRARY_PATH

# QT
echo "export qt"
export QTDIR=$WORK_DIR/qt4.8.6-none
export LD_LIBRARY_PATH=$QTDIR/lib:$LD_LIBRARY_PATH
export QT_QPA_PLATFORM_PLUGIN_PATH=$QTDIR/plugins
export QT_QPA_PLATFORM=linuxfb:tty=/dev/fb0:size=480x864:mmsize=25x15:offset=0
export QWS_DISPLAY=transformed:rot270:LinuxFB:mmWidth144:mmHeight72:0
export QT_QPA_FONTDIR=$QTDIR/lib/fonts
#export LD_PRELOAD=$WORK_DIR/libiconv-1.14-none/lib/preloadable_libiconv.so:$TSLIBDIR/lib/libts.so
export LD_PRELOAD=$TSLIBDIR/lib/libts.so
export QT_QPA_GENERIC_PLUGINS=tslib

if [ ! -d /data ]; then
  mkdir /data
fi

if [ ! -d /media ]; then
  mkdir /media
fi

if [ ! -d /data/pics ]; then
  mkdir /data/pics
else
  rm -f  /data/pics/*
fi


chmod  777 /opt/flashforge/exe/mydaemon.out
/opt/flashforge/exe/mydaemon.out &
if [ -f ${OLD_QTAPP} ] ;then
chmod  777  ${OLD_QTAPP}
echo "test start "${OLD_QTAPP}
${OLD_QTAPP}${RUNPARA}&
sleep 1;
rm -rf /opt/kernel
rm -rf /opt/control
rm -rf /opt/library
rm -rf /opt/software
fi
