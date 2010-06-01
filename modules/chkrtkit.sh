#!/bin/bash
#
# chkrtkit.sh - check for presence of rootkits on the system.

# !! THIS MUST BE PRESENT AT THE TOP OF EACH SCRIPT MODULE !!
# source config file, before doing anything else
if [ -r /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf ]; then 
		source /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf
else
	echo " $(basename $0): ERROR! Cannot source config file!"
	exit 1
fi
# -------------------

# where is chkrootkit installed...
CHKRK=$(which chkrootkit)

# where the real work happens
if [[ -z $CHKRK ]]; then 
	echo " * chkrootkit is not installed!"
	echo " * Please install app-forensics/chkrootkit!"
	echo ""
else
	echo " * You should probably be using rkhunter instead!" 
	$CHKRK -n -r $chkrtkit_dir_start 
	echo ""
fi

