#!/bin/bash
#
# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/eclean.sh,v 1.2 2008/06/07 17:38:39 root Exp $
#
# eclean.sh - check to see if the portage tree needs cleaning

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

# check cleanlieness of portage tree
echo " * Checking the cleanlieness of the Portage Tree..."
echo " * running eclean-dist..." 
/usr/bin/eclean-dist --nocolor --pretend 2>&1 
echo ""

echo " * running eclean-pkg..." >> $TMP_FILE
/usr/bin/eclean-pkg --nocolor --pretend 2>&1  
echo ""

