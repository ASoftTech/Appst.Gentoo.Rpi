# Video Output

## Overview

THe Rpi has a number of settings within config.txt that can be altered for the video output

  * https://www.raspberrypi.org/documentation/configuration/config-txt.md

## Overscan Settings

If using a monitor and you notice big black borders on the screen, one way to get rid of these is

```
disable_overscan=1
```

## VC4 Options

A couple of recomended settings for the 3D VC4 driver within config.txt include:

```
# VPU shouldn't handle V3D interrupts
mask_gpu_interrupt0=0x400
# VPU shouldn't smash our display setup.
avoid_warnings=2
```



## TODO

I've put some info here on selecting the default video resolution for an rpi on bootup

Based on this link:

  * [http://weblogs.asp.net/bleroy/getting-your-raspberry-pi-to-output-the-right-resolution](http://weblogs.asp.net/bleroy/getting-your-raspberry-pi-to-output-the-right-resolution)

### Get EDID Info

First to get the edid information

```
/opt/vc/bin/tvservice/tvservice -d edid
```

This should result in a file being outputed called edid with information pulled from the monitor <br />
The next command will parse that file and show us a list of supported resolutions

    edidparser edid

### Change the boot resolution

Next based on the output from before we're now going to change the default output resolution when the rpi boots

    nano /boot/config.txt

The two options to watch out for are

    hdmi_group=1
    hdmi_mode=16

Note:

* CEA = hdmi_group=1
* DMT = hdmi_group=2

The mode should equal the mode from the line output in edidparser
