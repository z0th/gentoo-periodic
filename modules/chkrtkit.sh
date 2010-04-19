#!/bin/bash
#
# chkrootkit.sh - check for presence of rootkits on the system.
#
# where is it installed...
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

