# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/mdraid_status.sh,v 1.1 2009/02/10 13:31:37 root Exp $ 

#!/bin/bash

#
# raid_status.sh - check status of mdadm raid.

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
for device in $RAID_DEV; do
	echo "    * Detail of $device:"
	mdadm --detail $device
	echo ""
done
}

echo " * Current status of (mdadm) RAID devices on this host"
# output based on options.
case ${RAID_VERBOSE} in
	[yY][eE][sS])
			 echo "    * Output of /proc/mdstat"
			 raid_basic
			 echo "    * Detail of RAID devices on this host"
			 raid_detail
	;;
	[nN][oO])
			 echo "    * Output of /proc/mdstat"
			 raid_basic
	;;
	*)
			 echo "mdraid_status.sh: Invalid argument! RAID_VERBOSE permits YES/NO options only!"
			 echo ""
	;;
esac

