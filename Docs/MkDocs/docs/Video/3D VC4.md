# 3D VC4 Acceleration

## Overview

The latest 4.5 kernel now has support for the VC4 driver for 3D.

I've been experimenting with different options but haven't managed to get this working just yet
the below is how far I've gotten so far.
One handy tip to see if the kernel has gotten as far as booting the os (but without a screen) is to check if the caps-lock key on the keyboard works.

  * http://anholt.livejournal.com/
  * https://dri.freedesktop.org/wiki/VC4/
  * https://cgit.freedesktop.org/mesa/mesa/
  * https://wiki.gentoo.org/wiki/Xorg/Hardware_3D_acceleration_guide

## Install

### Firmware

One very important step is to get the latest firmware from the linux rpi firmware git repo

  * https://github.com/raspberrypi/firmware
 
TODO add internal link

### Kernel

In order for VC4 to currently work, the VC4 driver needs to be enabled (not loaded as a module) as well as a couple of other tweaks to the config settings.
Such as disabling the default frame buffer.
See the vc4_bcm2709_cfg.diff file in the Kernel Building section which is what I'm working on at the moment.

Mostly its switching options from being loaded as a module, to being loaded directly into the kernel instead

Config             | Setting     | Location
------------------ | ----------- | ------------
CONFIG_FB_BCM2708  | Disabled(n) | Device Drivers -> Graphics Support -> Frame buffer Devices -> BCM2708 framebuffer support
CONFIG_DRM         | Enabled(y)  | Device Drivers -> Graphics Support -> Direct Rendering Manager
CONFIG_DRM_VC4     | Enabled(y)  | Device Drivers -> Graphics Support -> Broadcom VC4 Graphics
CONFIG_I2C_BCM2835 | Enabled(y)  | Device Drivers -> I2C support -> I2C Hardware Bus support -> Broadcom BCM2835 I2C controller

We also need to add the following to /boot/cmdline.txt
```
cma=256M@512M
```

It's best to use nano to avoid word wrapping
```
nano -w /boot/cmdline.txt
```

### Use Flags / Video Cards

I'd recommend enabling the following use flags

  * drm
  * gallium

Gallium is a new api within Mesa for 3D acceleration via drm (direct rendering manager)

Make sure vc4 is in the list of video devices */etc/portage/make.conf*
```
VIDEO_CARDS="fbdev fbturbo vc4"
```

### Config.txt Settings

One of the recomended changes is to /boot/config.txt

```
# VPU shouldn't handle V3D interrupts
mask_gpu_interrupt0=0x400
# VPU shouldn't smash our display setup.
avoid_warnings=2
```

Note the mask_gpu_interupt0 might not be needed in the later kernel, the main option needed though is this one
```
dtoverlay=vc4-kms-v3d
```
This is what enables vc4, but currently I've only being getting a black screen with no os boot.


### Mesa

On the userspace side we need to have the latest version of mesa
I've put a couple of ebuilds in the overlay as of writing

  * 11.2.0_rc3 from the 11.2 branch
  * 99999 for the latest master verison, based on the one from the gentoo arm overlay

Add the following to your keywords file */etc/portage/package.accept_keywords/default.keywords*
``
=media-libs/mesa-11.2.0_rc3 ~arm
```

Then install from the overlay
```
emerge =media-libs/mesa-11.2.0_rc3
```

### Video user group

For any users that use xorg, make sure they're added into the video user group

```
gpasswd -a $USER video
```

### Selecting the OpenGl implementation

First of all we can select the opengl library to use with the following
Ideally we want to make sure the default xorg setting is selected

```
eselect opengl list
eselect opengl set x
```

Make sure to select the xorg one

### Xorg.conf

Within the configuration for xorg we need to switch this acoss to modesetting (if you have enabled fbturbo then this replaces that setting).
This will cause xorg to use the kms (kernel mode setting) driver

```
Section "Device"
        Identifier      "Rpi FBDEV"
        Driver          "modesetting"
EndSection
```


## Benchmarking / Testing

There are two tools that can be used to benchmark the video I know of

  * glxgears (part of x11-apps/mesa-progs)
  * glmark2 (app-benchmarks/glmark2)
  * /usr/lib/misc/xscreensaver/lattice (x11-misc/rss-glx)

To get info on which gl driver is in use
```
glxinfo | grep render
```

## TODO

Still looking into how to get the VC4 driver to load at bootup

