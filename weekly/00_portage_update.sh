#!/bin/bash
#
# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/portage_update.sh,v 1.4 2009/04/13 12:36:51 root Exp $ 
#
# portage-update.sh - update the portage tree
#
NOW=`date +%F\ %R`
echo " * Updating the Portage tree: $NOW"
/usr/bin/emerge --nospinner --color=n --quiet --sync
echo " * Done!"
echo ""
echo " * Output of emerge --deep --update world"
/usr/bin/emerge --nospinner --color=n --deep --update --pretend world
echo "" 

