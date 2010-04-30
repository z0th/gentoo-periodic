#!/bin/bash
#
# chkrtkit.sh - check for presence of rootkits on the system.

# !! THIS MUST BE PRESENT AT THE TOP OF EACH SCRIPT MODULE !!
source_config() {
my_name=$(basename $0)
my_conf=$(find .. -name 'gentoo.periodic.conf')
if [[ -n $my_conf ]]; then
        source $my_conf
else 
	echo " * ERROR:" $my_name ": cannot source config!"
	exit 0
fi
}
source_config
# -------------------

# where is chkrootkit installed...
CHKRK=$( whereis -b -B /usr/sbin/ -f chkrootkit|awk -F\: '{print $2}'|sed 's/^[ ]*//' )
#
# dir structure to start check at.
chkrtkit_dir_start="/"

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

