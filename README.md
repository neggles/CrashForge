# CrashForge - Flashforge 3d Printer Unlocker
This is a set of scripts that you can use to unlock your FlashForge 3d Printer which will allow you full access to the underlying Linux distribution.
## Installation Steps:
1. Clone this repository or download these files as a .zip.
2. Format a USB stick as FAT32.
3. Unzip files (if necessary) and copy all files to the root of the USB stick.
4. Move the services you would like to activate from the /scripts/ folder into the /scripts/run folder.  
   
   The following services can be activated right now via this script, automatically.

     * samba
     * open-sshd
     * busybox /w netcat
   
   It can also change the root/ssh login password to the default, which is 12345.

5. Turn your printer completely OFF.
6. Unplug your printer, then turn the power switch on for 15 seconds.
7. Place the usb stick into the printer's front USB port.
8. Turn on your printer and wait.

   Your printer will now boot from the USB stick.
   
   #### DO NOT REMOVE THE USB STICK
   
   Once the printer has finished booting it will show a please wait notice on the screen.
   
   Once it has run all scripts it should show a completed notice on the screen.

   Power down your printer, plug in your printer to ethernet, or configure it via wifi.

   You can now access your printer via ssh if you have enabled it.
