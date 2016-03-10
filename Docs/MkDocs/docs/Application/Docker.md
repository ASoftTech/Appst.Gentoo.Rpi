# Docker

## Overview

One handy application I've found is Docker <br>
Docker is similar in some respects to a chroot, it allows for for a given process to run seperatly from the rest of the system.

  * The same kernel as the host is used to run the process in the docker image
  * The host kernel uses some special new features to enable process isolation
  * The docker instance can be paused / stopped / started
  * Each docker instance has it's own mini firewall for exposing ports to the outside.

One interesting use is the ability to publish Visual Studio ASP .Net 5 sites to a rpi.

## Kernel Options

If your using the grbd kernel sources with the bcm2709_grbdconfig then these options should already be turned on.
If your trying to find these options within *make menuconfig* then hit the / key to do a search while in the menu
(leave off the CONFIG when searching, e.g. search for MEMCG_SWAP not CONFIG_MEMCG_SWAP)



<table>
  <tbody>
    <tr>
      <th align="center">Location</th>
      <th align="center">Config Options</th>
    </tr>
    <tr>
      <td>
        Turn on everything except for debug under: <br>
        General Setup -> Control Group Support
      </td>
      <td>
        CONFIG_MEMCG_SWAP <br>
        CONFIG_MEMCG_SWAP_ENABLED <br>
        CONFIG_CGROUP_PERF <br>
        CONFIG_RT_GROUP_SCHED <br>
        CONFIG_CFS_BANDWIDTH
      </td>
    </tr>
    <tr>
      <td>
        Networking Support -> Networking options -> Network priority cgroup
      </td>
      <td>
        CONFIG_CGROUP_NET_PRIO
      </td>
    </tr>
    <tr>
      <td>
        It looks as if these are not available within Arm but they don't seem to be needed: <br>
        File systems --> Pseudo filesystems --> HugeTLB file system support
      </td>
      <td>
        CONFIG_CGROUP_HUGETLB <br>
        CONFIG_MEMCG_KMEM
      </td>
    </tr>
  </tbody>
</table>

## Installing Docker

So far I've tried version 1.10.2 without any problems on the rpi

```Bash
# Add the docker overlay
layman -a docker
# Install Docker
emerge --autounmask =app-emulation/docker-1.10.2
```

Docker runs as a service in the background so we need to start it up

```Bash
# Start the Service
/etc/init.d/docker start
# Add to default run level, to start on boot
rc-update add docker default
```

## Client Access

### Configuring Remote API

One of the features to setup is the remote api, to allow external applications to deploy or access the docker system.
Within **/etc/conf.d/docker** change the docker options to the following

```
DOCKER_OPTS="-H tcp://0.0.0.0:2376 -H unix:///var/run/docker.sock"
```

  * <http://www.virtuallyghetto.com/2014/07/quick-tip-how-to-enable-docker-remote-api.html>

Port **2376** seems to be the default port for docker, note the above settings don't include any form of authentication.
With the above options anyone on the internal network can connect to the docker instance.

### Command Line

docker has a very easy to use set of command line options

```
# List Docker Commands
docker --help
# List Docker Images
docker images
# Remove an Image
docker rmi <imageid>
# List all containers
docker ps -a
# Remove a Container
docker rm <containerid>
```

### Chrome DockerUI

There's a simple docker ui web gui on the Chrome store:

  * <https://chrome.google.com/webstore/detail/simple-docker-ui/jfaelnolkgonnjdlkfokjadedkacbnib?hl=en>

There's also a web based dockerui here

  * <https://github.com/crosbymichael/dockerui>
  * <http://linoxide.com/linux-how-to/setup-dockerui-web-interface-docker/>

Bearing in mind that the rpi is Arm not x86

### Visual Studio

For Visual Studio the url form you'll want to use is:

```
tcp://192.168.111.53:2376
```

TODO add blog link
