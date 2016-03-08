# Rpi3 Wifi Driver

## Overview

THe Rpi3 now has an inbuilt wifi driver without the need for a USB Dongle <br>
The inbuilt wifi driver appears to use a broadcom chipset, the **brcmfmac** driver

  * https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=138858
  * https://github.com/RPi-Distro/firmware-nonfree/tree/master/brcm80211/brcm

However the needed drivers are not currently yet part of the linux firmware git repo, or available via linux-firmware on gentoo.
Without the needed drivers you'll probably see something like this in the dmesg log

```
brcmfmac_sdio mmc1:0001:1: Direct firmware load for brcm/brcmfmac43430-sdio.bin failed with error -2
```

## Install Driver

There's now an ebuild to add in the needed firmware files, to use this you'll need to make sure the overlay for the Rpi is added in via layman first

```
emerge sys-kernel/rpi3-firmware
```

To test the driver
```
# Remove the Driver
modprobe -r brcmfmac
# Load in the Driver
modprobe brcmfmac
# Check Dmesg for any errors
dmesg
# List all network ports
ifconfig -a
```

## Auto Load at Boot

Edit the file **/etc/conf.d/modules**

And add in the following lines
```
# Rpi3 Wifi
modules="${modules} brcmfmac "
```

## Power Management Issues

It would seem that by default the wireless driver for the Rpi3 puts the inbuilt network wifi driver to sleep
after a while of non-useage. It can be woken up again with a ping, but ideally we don't want it to go to sleep in the first place.

  * <https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=138137&p=918295>

First make sure the iw tool is installed (this replaces iwconfig)
```
emerge net-wireless/iw
```

Next disable power management with
```
# Get the current state of power saving
iw dev wlan0 get power_save
# Turn off power saving
iw dev wlan0 set power_save off
```

To make this run on bootup, create a new file called */etc/local.d/20_wifi.start* <br>
With the following content

```
#!/bin/bash
iw dev wlan0 set power_save off
```