#!/bin/bash

# $Header: /home/drew/bin/projects/modules/RCS/file_bkup.sh,v 1.1 2009/09/09 20:02:01 drew Exp $

# file_bkup.sh - back up critical system files and directories.

# !! THIS MUST BE PRESENT AT THE TOP OF EACH SCRIPT MODULE !!
# source config file, before doing anything else
if [ -r /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf ]; then 
	source /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf
else
	echo " $(basename 0$): ERROR! Cannot source config file!"
	exit 1
fi
# -------------------

# default files to back up.
def_bkup="/etc/crontab /etc/fstab /etc/group /etc/gshadow /etc/passwd /etc/shadow"
# cating vars together 
bkup_files="${def_bkup} ${file_backup_opt_bkup}"

case ${file_backup_verbose} in 
	[yY][eE][sS])
		CP="${file_backup_cp} --verbose"
	;;
	*)
		CP=${file_backup_cp}	
		continue
	;;
esac 

# copy files f'n, if a dir then copy recursive;
# if a file then just copy; otherwise exit.
copy_files() {
	for file in $bkup_files; do
		if [ -d $file ]; then 
			$CP -R $file $file_backup_bkup_dest
			echo "   directory copied: $file"
		elif [ -f $file ]; then  
			$CP $file $file_backup_bkup_dest
			echo "   file copied: $file"
		else 
			echo " $(basename $0): ERROR! $file: does not exist or is not a regular file or directory!"
		fi
	done
}

# make sure dest dir exists, if not then create and/or copy. 
echo " * Backing up critical files and directories."
if [ -d $file_backup_bkup_dest ]; then
	echo " * Destination $file_backup_bkup_dest found!" 
	copy_files
	echo ""
else
	echo " * Destination $file_backup_bkup_dest does not exist! Creating..."
	mkdir -p $file_backup_bkup_dest
	copy_files
	echo ""
fi
   
