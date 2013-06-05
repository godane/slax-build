#!/bin/sh
# $1 = union directory
echo "Slax 7.0.0-core" >$1/etc/slax-version
touch $1/var/lock/001lock # make sure 001-core bundle will never be deactivated
chmod ago-x $1/etc/rc.d/rc.sshd
ln -s /mnt/live/bin/busybox $1/usr/bin/vi

# syslinux c32 files not need
rm -Rf $1/usr/share/syslinux

# unneeded, or wont work without dependency anyway
rm $1/usr/sbin/cifs.idmap

# ntp unneeded stuff, we want only ntpdate
rm $1/usr/sbin/ntpsnmpd
rm $1/usr/sbin/ntpq
rm $1/usr/sbin/ntpdc
rm $1/usr/sbin/ntpd
rm $1/usr/sbin/ntp-keygen

ln -s /mnt/live/bin/busybox $1/usr/bin/nslookup # better than 2MB big bind

# sg3 utils (needed lib for sdparm, not needed binaries)
rm $1/usr/bin/sg_*
rm $1/usr/bin/sgm_dd
rm $1/usr/bin/sgp_dd
