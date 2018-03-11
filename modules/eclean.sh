#!/bin/bash
#
# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/eclean.sh,v 1.2 2008/06/07 17:38:39 root Exp $
#
# eclean.sh - check to see if the portage tree needs cleaning

# !! THIS MUST BE PRESENT AT THE TOP OF EACH SCRIPT MODULE !!
# source config file, before doing anything else
if [ -r /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf ]; then 
		source /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf
else
	echo " $(basename $0): ERROR! Cannot source config file!"
	exit 1
fi
# -------------------

if [[ ${enable_eclean_dist} = [yY][eE][sS] ]] || [[ ${enable_eclean_pkg} = [yY][eE][sS] ]]; then 

	echo " * Running package tree clean-up checks." 
	echo " * Checks only, no files are removed!" 

	case ${enable_eclean_dist} in
		[yY][eE][sS])
			echo " * Running eclean-dist." 
			/usr/bin/eclean-dist --nocolor --pretend 2>&1 
			echo ""
			;;
		*)
			echo " * eclean-dist disabled." 
			echo "" 
		;;
	esac

	case ${enable_eclean_pkg} in
		[yY][eE][sS])
			echo " * running eclean-pkg."
			/usr/bin/eclean-pkg --nocolor --pretend 2>&1  
			echo ""
		;;
		*) 
			echo " * eclean-pkg disabled."
			echo ""
		;;
	esac
fi 

exit 0
