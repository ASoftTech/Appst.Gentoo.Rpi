# 2D FB Turbo Driver

## Overview

For 2D video on the Pi the default xorg driver is fbdev. <br>
There is also a better / bit faster driver available for the Arm processor called **fbturbo**

  * <https://github.com/ssvb/xf86-video-fbturbo>
  * <https://raw.githubusercontent.com/ssvb/xf86-video-fbturbo/master/xorg.conf>

## Install

### Video Cards section

First make sure the video cards setting is set to include fbturbo within */etc/portage/make.conf*

```sh
VIDEO_CARDS="fbdev fbturbo"
```

### Xorg Driver

Next we need to install xf86-video-fbturbo, the one from this overlay has been tweaked a bit for the Rpi
but is basically a copy and paste from the Gentoo Arm overlay

```sh
emerge --autounmask-write =x11-drivers/xf86-video-fbturbo-20150806
etc-update
emerge =x11-drivers/xf86-video-fbturbo-20150806
```

### Xorg Configuration

Finally we need to add fbturbo into the xorg configuration.
With the latest gentoo everything under the */etc/X11/xorg.conf.d/* directory is merged into one file
before being run. So just create a new file called **/etc/X11/xorg.conf.d/30fbturbo.conf** with the below
content in to load fbturbo

```
Section "Device"
        Identifier      "Rpi FBDEV"
        Driver          "fbturbo"
        Option          "fbdev" "/dev/fb0"
        Option          "SwapbuffersWait" "true"
EndSection
```


## TODO

Test with and without the fbturbo driver

add dbus to default runlevel during setup
```
rc-update add dbus default
```
