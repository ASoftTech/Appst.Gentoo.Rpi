# X2Go RDP

## Overview

In order to access a remote desktop on the Rpi over the network.
I've found the best way to do this is to use X2Go.

X2go works by establishing a ssh client session.
then running the desktop manager directly over that connection

For the windows client you can download that here

  * http://wiki.x2go.org/doku.php

## Rpi Install

To install x2go server.

```sh
emerge net-misc/x2goserver
```

Next we need to create the x2go database
```
x2godbadmin --createdb
```
