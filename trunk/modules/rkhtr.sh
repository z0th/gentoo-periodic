#!/bin/bash
#
# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/rkhtr.sh,v 1.5 2009/02/23 15:51:11 root Exp $
#
# rkhtr.sh - check for presence of rootkits on the system.
#
RKHTR=`which rkhunter`

if [[ -z $RKHTR ]]; then 
   echo " * rkhunter is not installed!"
	echo " * Please install app-forensics/rkhunter"
	echo ""
else
	echo " * Updating and running rkhunter"
	$RKHTR --quiet --nocolors --update && \
	$RKHTR --check --nocolors --skip-keypress
	echo "" 
fi
