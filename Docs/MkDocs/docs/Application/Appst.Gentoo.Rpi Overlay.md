# Appst.Gentoo.Rpi Overlay

This is my own custom overlay for the rpi, I've included a few ebuilds that may be useful

### Install

To add into the system
```
layman -f -a Appst-Gentoo-Rpi -o https://raw.githubusercontent.com/ASoftTech/Appst.Gentoo.Rpi/master/Appst-Gentoo-Rpi.xml
```

## Rpi Monitor

Rpi Monitor Allows you to see the current state of the Rpi in terms of cpu useage etc <br>
This ebuild is a copy of the one from srcshelton's overlay [Link](https://gpo.zugaina.org/www-apps/rpi-monitor)

To Install
```
# To Install
emerge www-apps/rpi-monitor

# To Start
/etc/init.d/rpimonitor start
```

At this point the web interface should be visible on port 8888 by default

  * http://Rpi_IP:8888/status.html

## RPi-GPIO

This package appears to be a python library for accessing the Rpi's gpio pins
I've pulled the version from the Gentoo arm overlay and upped the version number
since the sources for the older version appear to be no longer available

To install
```
emerge --autounmask-write =dev-python/RPi-GPIO-0.6.2
```

## rpi3-firmware

This is ebuild which installs the needed firmware files to allow the inbuilt wireless driver
to work for the Rpi3

To install
```sh
emerge rpi3-firmware
```

## grbd-rpi-sources

These are the kernel sources I've been using for my own use, at the time of writing 4.5rc6 should be in there
along with a configuration file to enable docker

To install
```
emerge =sys-kernel/grbd-rpi-sources-4.5_rc6
```

## xf86-video-fbturbo

This is an ebuild copied and pasted from the Gentoo Arm overlay. <br>
The differences include

  * The git commit is fixed to a point in time
  * I've set the EAPI to version 5 so that it pulls from the git repo
  * Removed the dependency on the exynos video card

To install

```
emerge --autounmask-write =x11-drivers/xf86-video-fbturbo-20150806
etc-update
emerge =x11-drivers/xf86-video-fbturbo-20150806
```

## glmark2

I've also added in the ebuild for glmark2 for benchmarking the video

  * https://github.com/glmark2/glmark2

```
emerge --autounmask-write =app-benchmarks/glmark2-9999
etc-update
emerge =app-benchmarks/glmark2-9999
```

## TODO

look into ebuilds under media-libs
