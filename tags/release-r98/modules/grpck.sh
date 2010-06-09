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
# catch the last exit status
found=$?
case $found in
	0)	# success! no unused entries
		echo "  * Success! No unused groups found!"
		exit 0
	;;
	1)	# invalid cmd syntax
		echo "  * Error! grpck.sh: Invalid syntax."
		exit 1
	;;
	2)	# one or more bad group entries
		echo "  * One or more bad group entries found!"
		exit 0
	;;
	3)	# cant open group file
		echo "  * Error! grpck.sh: Cannot read $grpck_grpfile."
		exit 1 
	;;
	4)	# cant lock group file 
		echo "  * Error! grpck.sh: Cannot lock $grpck_grpfile."
		exit 1 
	;;
	5)	# cant update group file, should never see this since in ro mode
		echo "  * Error! grpck.sh: Cannot update $grpck_grpfile (this error should not be seen)."
		exit 1 
	;;
	*) # this is a catch all, some other horrendous error
		echo "  * Error! grpck.sh: Unknown error."
		exit 1 
	;;
esac

