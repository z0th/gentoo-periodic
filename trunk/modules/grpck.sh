# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/grpck.sh,v 1.1 2008/11/21 15:09:37 root Exp $
#
# grpck.sh - check for unused groups.
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

echo " * Checking for unused groups..."
/usr/sbin/grpck -r $grpchk_grpfile
echo ""

