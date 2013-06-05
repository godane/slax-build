#!/bin/bash
# $1 = union dir
chmod a+x $1/etc/rc.d/rc.networkmanager
rm $1/usr/share/applications/*
