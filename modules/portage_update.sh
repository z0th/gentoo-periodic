#!/bin/bash
#
# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/portage_update.sh,v 1.5 2009/09/06 21:53:31 root Exp $ 
#
# portage-update.sh - update the portage tree
#
NOW=`date +%F\ %R`
echo " * Updating the Portage tree: $NOW"
/usr/bin/emerge --nospinner --color=n --quiet --sync
echo " * Done!"
echo " * Output of emerge --deep --update world"
/usr/bin/emerge --nospinner --color=n --deep --update --pretend world 
echo "" 

