# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/grpck.sh,v 1.1 2008/11/21 15:09:37 root Exp $
#
# pwck.sh - check the passwd and shadow files for errors.
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


run_pwck() {
	/usr/sbin/pwck -rq 2>&1 
}

case pwck_enable in 
	[Yy][Ee][Ss])
		echo " * Checking user authentication data..."
		run_pwck   
		echo ""
		;;
	*)
		echo " * pwck.sh not enabled."
		echo "" 
		;; 
esac



