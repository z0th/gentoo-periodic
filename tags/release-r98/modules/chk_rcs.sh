#!/bin/bash
#
# $Header: /home/drew/bin/projects/gentoo-periodic/modules/RCS/chk_rcs.sh,v 1.2 2009/09/14 16:51:19 drew Exp $
#
# chk_rcs.sh - check the system for checked in/out files.
#
# !! THIS MUST BE PRESENT AT THE TOP OF EACH SCRIPT MODULE !!
# source config file, before doing anything else
if [ -r /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf ]; then 
	source /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf
else
	echo " $(basename $0): ERROR! Cannot source config file!"
	exit 1
fi
# -------------------

# is rcs even installed? 
RCS_INSTALLED=$(which rcs)

if [ -n $RCS_INSTALLED ]; then
	# find files
	echo " * Searching for RCS files."	
	find / -path '/home/' -prune -o -name '*,v' -type f -exec rlog -l -h {} \;
	echo ""
else
	echo " * RCS is not installed!"
	echo " * Please install app-text/rcs or equivalent package!"
	echo ""
fi

