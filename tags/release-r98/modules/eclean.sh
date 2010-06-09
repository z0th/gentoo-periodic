#!/bin/bash
#
# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/eclean.sh,v 1.2 2008/06/07 17:38:39 root Exp $
#
# eclean.sh - check to see if the portage tree needs cleaning

# !! THIS MUST BE PRESENT AT THE TOP OF EACH SCRIPT MODULE !!
# source config file, before doing anything else
if [ -r /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf ]; then 
		source /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf
else
	echo " $(basename $0): ERROR! Cannot source config file!"
	exit 1
fi
# -------------------

# check cleanlieness of portage tree
echo " * Checking the cleanlieness of the Portage Tree..."
echo " * running eclean-dist..." 
/usr/bin/eclean-dist --nocolor --pretend 2>&1 
echo ""

echo " * running eclean-pkg..." >> $TMP_FILE
/usr/bin/eclean-pkg --nocolor --pretend 2>&1  
echo ""

