# 3D VC4 Acceleration

## Overview

The latest 4.5 kernel now has support for the VC4 driver for 3D.
The default kernel configuration will compile this as a module

  * https://dri.freedesktop.org/wiki/VC4/
  * https://cgit.freedesktop.org/mesa/mesa/
  * https://wiki.gentoo.org/wiki/Xorg/Hardware_3D_acceleration_guide

## Install

### Kernel Module

To load in the 3d driver
```
modprobe vc4
```

To make the module load at runtime edit the **/etc/conf.d/modules** file and add the following

```
# VC4 3D Module
modules="${modules} vc4 "
```

### Use Flags

I'd recommend enabling the following use flags

  * drm
  * gallium

Gallium is a new api within Mesa for 3D acceleration via drm (direct rendering manager)

### Mesa

On the userspace side we need to have the latest version of mesa
I've put a couple of ebuilds in the overlay as of writing

  * 11.2.0_rc3 from the 11.2 branch
  * 99999 for the latest master verison, based on the one from the gentoo arm overlay

Add the following to your keywords file */etc/portage/package.accept_keywords/default.keywords*
``
=media-libs/mesa-11.2.0_rc3 ~arm
```

Make sure vc4 is in the list of video devices */etc/portage/make.conf*
```
VIDEO_CARDS="fbdev fbturbo vc4"
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

### Selecting the OpenGl in use

First of all we can select the opengl library to use with the following

```
eselect opengl list
eselect opengl set x
```

Make sure to select the xorg one

## Benchmarking

There are two tools that can be used to benchmark the video I know of

  * glxgears
  * glmark2

To get info on which gl driver is in use
```
glxinfo | grep render
```

## TODO

Still looking into how to get the VC4 driver to load in xorg
