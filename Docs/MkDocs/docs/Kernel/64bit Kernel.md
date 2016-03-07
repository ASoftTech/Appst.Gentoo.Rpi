# 64Bit Kernel

## Overview

The latest Rpi3 has a BCM2710 / BCM2837 Arm CPU.
This happens to be a 64bit Armv8 cpu. At the moment all Rpi distro's are based on 32bit.
In theory if the kernel has support for it we may be able to get 64bit working on the Rpi 3.

So far I've not managed to get a 64bit kernel working / building but I've included what steps I've included so far for anyone else who'd like to try this.

  * <https://archives.gentoo.org/gentoo-embedded/message/9b96f5fd00a9c5e65e062f3d6e99fc50>
  * <http://gentoo.osuosl.org/experimental/arm64/>


## Setting up Crossdev

Gentoo has a handy tool called Crossdev available we can in theory use to compile the 64bit kernel on a 32bit system.

First we need to make sure /etc/portage/package.use is a directory and not a file,
if it is a file then move it somewhere else then create a directory and move the file into it.

### Installing crossdev

With gentoo we can install crossdev with
```sh
emerge crossdev
```

### Creating the Toolchain

After installing crossdev the next step is to let crossdev know to create a toolchain for the arm64 arch
```sh
crossdev arm64
```

At this point the tools will be located within **/usr/aarch64-unknown-linux-gnu/** <br>
such as *aarch64-unknown-linux-gnu-gcc*


## Prep the kernel sources

### Download Sources

Next we need to get the latest kernel sources

For the latest 4.5 kernel release we can ether do a git pull on <https://github.com/raspberrypi/linux/tree/rpi-4.5.y> <br>
Or just copy and paste the sources from the installation directory for the grbd-rpi-sources ebuild

```Bash
cd /usr/src/
cp -a linux-4.5-rc6-grbd linux-4.5-rc6-grbd-arm64
cd linux-4.5-rc6-grbd-arm64
```

### Clean Sources

Next lets make sure the sources have been cleaned

```
make distclean
```

### Configure Sources

Next we want to make sure the kernel modules are installed in a different directory to prevent overlap with the 32bit kernel modules.
Edit the **Makefile** and make sure to add **-arm64** to the extraversion

Copy and paste the config file that's been used before for the 32bit kernel sources to use as a basis
```Bash
cp ../linux-4.5-rc6-grbd/.config ./
```

For the final config step we want to use oldconfig to filter the settings for that arch and possibly menuconfig to add in any additional settings we want.
In order to tell the kernel we're compiling for arm64 instead of arm we use the ARCH and CROSS_COMPILE options for make.

```Bash
make ARCH=arm64 CROSS_COMPILE=aarch64-unknown-linux-gnu- oldconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-unknown-linux-gnu- menuconfig
```

Note when running oldconfig more than likley a large nunber of options will crop up, so far I accepted the defaults for everything,
and enabled anything with the word *Broadcom* in the name

## Build the Sources

Now we can do the actual build.
I tend to run build within tmux so that I can detach and leave the build running then come back to it

It doesn't look as if arm64 has zImage support yet (Image is uncompressed, zImage is compressed with gzip so is just smaller for the boot drive)

```Bash
make ARCH=arm64 CROSS_COMPILE=aarch64-unknown-linux-gnu- -j4 Image modules dtbs
```

For a break down of the different options:

  * -j4 - use all 4 cores of the rpi to speed up the compile
  * Image - compile the main kernel image uncompressed
  * modules - compile needed kernel modules
  * dtbs - compile the device tree's 

## Install the Sources

Finally we need to install the kernel sources into boot

This will install the kernel modules into /lib/modules/
```Bash
make ARCH=arm64 CROSS_COMPILE=aarch64-unknown-linux-gnu- INSTALL_MOD_PATH=/root/arm64kern modules_install
```

Next we copy the kernel across to boot, the kernel needs to be parsed via mkknlimg with 32bit kernels so I'm assuming the same is needed here
```Bash
scripts/mkknlimg arch/arm/boot/zImage /root/arm64kern/boot/kernel-arm64-gentoo1.img
```




## TODO

Look into passing device tree's, cflags, tell config.txt to enter aarch64 mode.

  * <https://forums.gentoo.org/viewtopic-p-7887518.html?sid=34d969f3f0ad50798d09d52784030f88>

Is there a difference between the device tree files for 64bit?

```Bash
cp arch/arm64/boot/dts/*.dtb* /boot/
cp arch/arm64/boot/dts/overlays/*.dtb* /boot/overlays/
```
