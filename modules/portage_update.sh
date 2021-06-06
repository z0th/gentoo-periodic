#!/bin/bash
#
# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/portage_update.sh,v 1.5 2009/09/06 21:53:31 root Exp $ 
#
# portage-update.sh - update the portage tree
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

NOW=`date +%F\ %R`
echo " * Updating the Portage tree: $NOW"
$portage_update_cmd 1>/dev/null 
echo " * Done!"
echo " * Output of emerge --deep --update world"
$portage_update_display 2>&1  
echo "" 

