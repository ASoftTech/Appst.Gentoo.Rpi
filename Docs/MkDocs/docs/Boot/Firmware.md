# Upgrading the Firmware

## Overview

I've found that updating the firmware files under /boot/ is an important part of getting the 3D VC4 DRM drivers to work.
Be very careful with the below as it's possible to end up with an unbootable system if your not careful.

## Backup old Firmware

First we're going to make a backup copy of the old firmware files just to be safe


```
cd /boot/

# Create some place to put the backup files
mkdir oldfirmware

# Make a copy of the old firmware files
cp start* oldfirmware/
cp fixup* oldfirmware/
cp bootcode.bin oldfirmware/

# Backup the settings
cp cmdline.txt oldfirmware/
cp config.txt oldfirmware/
```

## Upgrade Firmware

Next we're going to replace the firmware files with the newer ones

### Download Firmware

Let's create somewhere outside of boot (since boot has limited space) to put the files from the rpi firmware repo on github
```
mkdir /root/temp1
cd /root/temp1
```

Next lets download a snapshot of the repo

```
# For the latest firmware
wget https://github.com/raspberrypi/firmware/archive/master.zip

# For 2016-03-11
wget https://github.com/raspberrypi/firmware/archive/8b4e5482b52e6fb438dddc0d88ba0ba8d44af54b.zip
```

### Copy Firmware

Uncompress the snapshot
```
unzip master.zip
cd firmware-master/boot/
```

Finally lets copy the firmware files across to boot
```
cp bootcode.bin /boot/
cp start* /boot/
cp fixup* /boot/
```

### Dtb Files

The Dtb files are called device tree files, the importing thing to note is that these need to match up with the version of the kernel your using
so you should only copy them over from the above firmware git repo if your planning on using the kernel image (usually kernel7.img for rpi2 / 3)
from the same repo.
