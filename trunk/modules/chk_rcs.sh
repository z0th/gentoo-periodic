#!/bin/bash
#
# $Header: /home/drew/bin/projects/gentoo-periodic/modules/RCS/chk_rcs.sh,v 1.2 2009/09/14 16:51:19 drew Exp $
#
# chk_rcs.sh - check the system for checked in/out files.
#

# is rcs even installed? 
RCS_INSTALLED=`which rcs`

if [ -n $RCS_INSTALLED ]; then
	# find files 
	find / -path '/home/' -prune -o -name '*,v' -type f -exec rlog -l -h {} \;
else
	echo " * RCS is not installed!"
	echo " * Please install app-text/rcs or equivalent package!"
	echo ""
fi

