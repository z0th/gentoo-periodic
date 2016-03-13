#!/bin/bash
# 
# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/glsa_check.sh,v 1.4 2008/06/07 17:32:27 root Exp $
# 
# glsa-check.sh - check for security issues
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

glsa_cmd() {
	$glsa_check_cmd  
}

case ${enable_glsa_check} in
	[yY][eE][sS])
		echo " * Checking for local security issues..."
		glsa_cmd  
		echo ""
	;; 
	*)
		echo " * glsa_check.sh disabled."
		echo ""
		exit 1 
	;;
esac

exit 0
