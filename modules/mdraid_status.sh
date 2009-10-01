# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/mdraid_status.sh,v 1.1 2009/02/10 13:31:37 root Exp $ 

#!/bin/bash

#
# raid_status.sh - check status of mdadm raid.

# raid devices to consider
RAID_DEV="/dev/md1 /dev/md2"
DETAIL=no

# basic output
echo " * Status of RAID devices on this host"
# output of /proc/mdstat
echo " * Output of /proc/mdstat"
cat /proc/mdstat 
echo "" 

# detailed output from mdadm 
case "${DETAIL}" in
	[yY][eE][sS])
		for device in $RAID_DEV; do
			echo " * Detail of $device:"
			mdadm --detail $device
			echo "" 
		done
	;;
	*)
	;; 
esac
