#!/bin/bash
#
# chkrtkit.sh - check for presence of rootkits on the system.

# ----------------
# this code sources the config file! must be at the top of every module! 
my_name=$(basename $0)
# source config
if [ -e $INSTALL_DIR/gentoo.periodic.conf ]; then
   . $INSTALL_DIR/gentoo.periodic.conf 
else 
   echo " * ERROR:" $my_name ": cannot source config!"
   exit 0
fi
# ----------------

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

