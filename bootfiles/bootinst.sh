#!/bin/sh
# Setup Slax booting from disk (USB or harddrive)
# Requires: extlinux, fdisk, dd
# No commandline arguments.
set -e

# Dummy check for extlinux, to make sure extlinux exists
# even before any further analysis. If doesn't exist, script ends
VERSION=$(extlinux -v 2>&1)

# change working directory to dir from which we are started
CWD="$(pwd)"
BOOT="$(dirname "$0")"
cd "$BOOT"

# find out device and mountpoint
PART="$(df . | tail -n 1 | tr -s " " | cut -d " " -f 1)"
DEV="$(echo "$PART" | sed -r "s:[0-9]+\$::" | sed -r "s:([0-9])[a-z]+\$:\\1:i")"   #"

# check if disk is already bootable. Mostly for Windows discovery
if [ "$(fdisk -l "$DEV" | fgrep "$DEV" | fgrep "*")" != "" ]; then
   echo ""
   echo "Partition $PART seems to be located on a physical disk,"
   echo "which is already bootable. If you continue, your drive $DEV"
   echo "will boot only Slax Linux by default."
   echo "Press [Enter] to continue, or [Ctrl+C] to abort..."
   read junk
fi

# install syslinux bootloader
extlinux --install $BOOT

if [ "$DEV" != "$PART" ]; then
   # Setup MBR on the first block
   dd bs=440 count=1 conv=notrunc if="$BOOT/mbr.bin" of="$DEV"

   # Toggle bootable flags
   PART="$(echo "$PART" | sed -r "s:.*[^0-9]::")"
   (
      fdisk -l "$DEV" | fgrep "*" | fgrep "$DEV" | cut -d " " -f 1 \
        | sed -r "s:.*[^0-9]::" | xargs -I '{}' echo -ne "a\n{}\n"
      echo -ne "a\n$PART\nw\n"
   ) | fdisk $DEV >/dev/null 2>&1
fi

echo "Boot installation finished."
cd "$CWD"
