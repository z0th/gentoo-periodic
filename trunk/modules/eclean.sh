#!/bin/bash
#
# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/eclean.sh,v 1.2 2008/06/07 17:38:39 root Exp $
#
# eclean.sh - check to see if the portage tree needs cleaning
#
echo " * Checking the cleanlieness of the Portage Tree..."
echo " * running eclean-dist..." 
/usr/bin/eclean-dist --nocolor --pretend 2>&1 
echo ""

echo " * running eclean-pkg..." >> $TMP_FILE
/usr/bin/eclean-pkg --nocolor --pretend 2>&1  
echo ""

