# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/mdraid_status.sh,v 1.1 2009/02/10 13:31:37 root Exp $ 

#!/bin/bash

#
# raid_status.sh - check status of mdadm raid.

# !! THIS MUST BE PRESENT AT THE TOP OF EACH SCRIPT MODULE !!
# source config file, before doing anything else
if [ -r /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf ]; then 
	source /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf
	else
echo " $(basename 0$): ERROR! Cannot source config file!"
	exit 1
fi
# -------------------

# raid devices to consider
RAID_DEV="/dev/md1 /dev/md2"
# be verbose?
RAID_VERBOSE=NO

# functions for status output
raid_basic() {
	cat /proc/mdstat
	echo ""
}

raid_detail() {
# detail output
for device in $raid_status_devs; do
	echo "    * Detail of $device:"
	mdadm --detail $device
	echo ""
done
}

echo " * Current status of (mdadm) RAID devices on this host"
# output based on options.
case ${raid_status_verbose} in
	[yY][eE][sS])
			 echo "    * Output of /proc/mdstat"
			 raid_basic
			 echo "    * Detail of RAID devices on this host"
			 raid_detail
	;;
	*)
			 echo "    * Output of /proc/mdstat"
			 raid_basic
	;;
esac

