#!/bin/bash
# 
# check_mount.sh - ensure that some mounts are present.
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


case "$mount_check_enable" in 
	[yY][eE][sS])  
		# name of the mountpoint, sourced from config
		#mount_name"/full/path"
		# mountpoint present? 0 = yes; 1 = no
		
		echo " * checking for mountpoints: ${mount_name} "
		# if mounted, do nothing, else error 
		for point in $mount_name; do 
			mount_check=$(mount | fgrep --quiet "${point}"; echo $?)
			if [ $mount_check -eq "0" ]; then 
				echo "     * INFO: ${point} is mounted."
				echo "" 
			else 
				echo "     * WARNING: mountpoint ${point} is missing!"
				echo "" 
				# scrape fstab for the point
				#scrape_fstab
			fi	
		done
		echo ""
		exit 0
	;;
	*)
		# nothing to see here
		echo " * mount_check_enable set to $mount_check_enable in config, doing nothing!"
		echo "" 
		exit 1 
	;;		
esac

