# $Header$
#
# clam_scan.sh - update ClamAV scan database. Scan things.
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

fc_update() {
	on_error="err='true'"
	on_update="update='true'"	
	$(which freshclam) --quiet --log=/var/log/clamav/freshclam.log \
		--on-error-execute=${on_error} \
		--on-update-execute=${on_update} 
	fc_exitcode=$?
} 



# is freshclam installed?
type -p freshclam > /dev/null 2>&1 
# catch the last exit status
found=$?

case $found in
	0)	# success! no unused entries
		echo " * Updating ClamAV signature database..."
		fc_update 
		echo " * Done!"
		# then scan stuff
		exit 0
	;;
	1)	# invalid cmd syntax
		echo "  * $0: freshclam is not installed! "
		exit 1
	;;
	*) # this is a catch all, some other horrendous error
		echo "  * $0: Unknown error."
		exit 1 
	;;
esac

