# Kernel Building

## Overview

There are currently 3 different architectures for the Raspberry Pi

Rpi Model    | Arm Version   | Device Family | Device Model
------------ | ------------- | ------------- | ------------
Rpi 1 / Zero | Armv6         | BCM2708       | BCM2835
Rpi 2        | Armv7         | BCM2709       | BCM2836
Rpi 3        | Armv8 (64bit) | BCM2710       | BCM2837

From 4.5 onwards there should be support for the Rpi but from what I've discovered
there are still missing bits required to get things running such as the default config files
or the mkknlimg script to prepare the kernel image.

To get your current kernel version
```Bash
uname -r
```

## Downloading the Sources

The main source for the rpi kernel sources is

  * <https://github.com/raspberrypi/linux/>

For gentoo ebuilds there is the following:

  * **sys-kernel/raspberrypi-sources** - Official Gentoo repo rpi sources
  * **sys-kernel/grbd-rpi-sources** - This is my own custom kernel sources, with the more recent 4.5 and a configuration file for Docker.

So far I've used 4.5rc6 with the Rpi3 which seems to work fine. One of the benifits of 4.5 is going to be accelerated 3D Support
and there seems to be a lot of updates and changes in relation to Arm. To use grbd-rpi-sources you'll need to add in the overlay

TODO add overlay link

```Bash
emerge --autounmask-write =sys-kernel/grbd-rpi-sources-4.5_rc6-r1
etc-update
emerge =sys-kernel/grbd-rpi-sources-4.5_rc6-r1
```

Note typically any version numbers ending in 9999 will get the latest version from github

Next we need to select which kernel source to use
```
cd /usr/src
rm linux
ln -s linux-4.5-rc6-grbd-r1 linux
cd linux
```

When installing applications under gentoo, they tend to use the /usr/src/linux directory to figure out which options are enabled
It's also possible to use ```eselect kernel list``` and ```eselect kernel set``` to acomplish the same thing as above.


## Configuring the Sources

There's a number of different configuration files available under **arch/arm/configs/**

  * **bcmrpi_defconfig** - Default Configuration for the Rpi1 / Zero
  * **bcm2709_defconfig** - Default Configuration for the Rpi2 / Rpi3
  * **docker_bcm2709_cfg.diff** - Patch config settings for Docker
  * **vc4_bcm2709_cfg.diff** - Patch config settings for VC4

If your using grbd-rpi-sources then I've included a file called bcm2709_grbdconfig for enabling Docker.

### Cleaning the sources

In order to clear out the build files from a prior build we can use the folllowing <br>
Note this will erase the .config configuration file so make sure to back it up before cleaning if it's been set already

```
make distclean
```

### Rpi1  / Rpi Zero Config

I've found that running make oldconfig will filter / clean up the settings for where a older configuration file is used

```
make bcmrpi_defconfig
make oldconfig
```

### Rpi2 / Rpi3 Config

```
# Default Config for Rpi2
make bcm2709_defconfig

# If your using the grbd sources, then there's a patch to the config to enable docker on the Rpi2
patch -p1 .config arch/arm/configs/docker_bcm2709_cfg.diff
```

At the time of writing I'm still struggling to get vc4 to work (black screen)
but I believe this should apply some of the settings needed for those that want to experiment.
Note this disables the default framebuffer driver so that vc4 can take over instead, but so far I've not managed
to get this to work yet.
```
patch -p1 .config arch/arm/configs/vc4_bcm2709_cfg.diff
```


### Additional Settings

If you want to customise the config further just use
```
make menuconfig
```
You can also use the / key to search for a given option within the menu

## Building the Kernel Sources

Building the kernel is fairly straightforward, personally I tend to run this within tmux so I can detach from ssh and leave it running then come back to it later.

  * **-j4** - This means to use all 4 cores when compiling the kernel to speed up the kernel compile
  * **zImage** - Create a gzip compressed kernel image
  * **modules** - Compile the needed kernel modules
  * **dtbs** - Compile the needed device tree files

```Bash
make -j4 zImage modules dtbs
```

## Installing the Kernel Sources

### Installing the kernel modules

The first step is to install the kernel modules onto the system <br>
This should copy the kernel modules into the directory /lib/modules/kernel-version
```Bash
make modules_install
```

### Installing the kernel image

Next we want to copy across the kernel image to boot, we use the mkknlimg script to do this as it also modify's the kernel in such a way to make it bootable via Noobs.
It's important to make sure to not overwrite your current bootable kernel (we can switch between different ones with config.txt)
```Bash
scripts/mkknlimg arch/arm/boot/zImage /boot/kernel7-gentoo-new1.img
```

Generally speaking kernel.img is the default name for Rpi1 / Zero, and kernel7.img is the default name for Rpi2 / Rpi3

### Installing the Device Tree Files

The device tree files tend to need updating when new Rpi devices come out such as the Rpi3
```Bash
cp arch/arm/boot/dts/*.dtb* /boot/
cp arch/arm/boot/dts/overlays/*.dtb* /boot/overlays/
```

### External Kernel Modules

If you have any external kernel modules that need recompiling due to a change of kernel
```sh
emerge --ask @module-rebuild
```

## Setting the Kernel to boot

Finally we want to switch config.txt across to using the kernel to test it out.
If for any reason something goes wrong we can hold down **shift** at bootup, click e to edit the config.txt file within Noobs, to get back to a bootable kernel

Sometimes there won't be a entry for the old kernel, in which case just add this as a new line
to the config.txt

```Bash
nano -w /boot/config.txt
```

```
# Original
#kernel=kernel7-raspian.img

# New
kernel=kernel7-gentoo-new1.img
```

Finally lets reboot / test
```sh
reboot
```
