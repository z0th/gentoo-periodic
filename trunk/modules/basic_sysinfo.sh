#!/bin/bash
#
# basic_sysinfo.sh - the basics of stuff you want to know.

# !! THIS MUST BE PRESENT AT THE TOP OF EACH SCRIPT MODULE !!
# source config file, before doing anything else
if [ -r /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf ]; then 
	source /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf
else
	echo " $(basename $0): ERROR! Cannot source config file!"
	exit 1
fi
# -------------------

# disk usage
disk_usage() { 
case "basic_sysfinfo_disk_usage_virtual" in 
	[Yy][Ee][Ss])	# host is a virtual server, only has /
		echo " * Current disk usage, all devices."
		df --human-readable /
		echo ""
	;;
	[Nn][Oo])	# host is typical box with standard partitions
		echo " * Current disk usage, all devices."
		df --all --human-readable
		echo ""
	;;
esac
}

# current user logins
current_logins() {
echo " * Users currently logged in."
w -f -s 
echo "" 
}

# interface stats
iface_stats() {
echo " * Interface statistics."
netstat -in
echo ""
}

# listening processes
listen_pids() {
echo " * Listening processes."
netstat --tcp --udp --program --listening --numeric-hosts --wide
echo ""
}

# running screens
running_screens() {
echo " * Currently running screen sessions."
ps ajx | fgrep SCREEN | grep -v "fgrep"
echo ""
}


# if enabled, call various things.
case $enable_basic_sysinfo in 
	[Yy][Ee][Ss])
		disk_usage
		current_logins
		iface_stats
		listen_pids
		running_screens
	;;
	*)
		echo " * basic system info output disabled."
		echo ""
	;; 
esac

