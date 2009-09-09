#!/bin/bash
#
# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/chkrtkit.sh,v 1.2 2008/04/04 18:59:46 root Exp $
#
# chkrootkit.sh - check for presence of rootkits on the system.
#
CHKRK=`whereis -b -B /usr/sbin/ -f chkrootkit|awk -F\: '{print $2}'|sed 's/^[ ]*//'`

if [[ -z $CHKRK ]]; then 
	echo " * chkrootkit is not installed!"
	echo " * Please install app-forensics/chkrootkit!"
	echo ""
else
	$CHKRK -n -r /
	echo ""
fi

