# Samba

## Overview

for gentoo to install samba
emerge samba
cp /etc/samba/smb.conf.default /etc/samba/smb.conf

make sure under the [homes] section that browsable is set to yes
under the smbusers file we can add alias's to match samba users against unix users
unixuser = sambauser

we need to add the unix user to the samba database
smbpasswd -a richard
then enter samba password
