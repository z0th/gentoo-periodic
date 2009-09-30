#!/bin/bash

# $Header: /home/drew/bin/projects/modules/RCS/file_bkup.sh,v 1.1 2009/09/09 20:02:01 drew Exp $

# file_bkup.sh - back up critical system files and directories.

# default files/dirs to be backed up
def_bkup="/etc/passwd /etc/group /etc/shadow /etc/gshadow"
# optional files/dirs to be backed up
opt_bkup="/etc/hosts /etc/make.conf /etc/mdadm.conf"
# backup destination
BKUP_DEST="/data/backup/daily-backup"
# be verbose? 
VERBOSE=no
# cating vars together 
BKUP_FILES="${def_bkup} ${opt_bkup}"
# flags to hand to cp 
CP="cp --preserve=all --parents --no-dereference --update"

case ${VERBOSE} in 
	[yY][eE][sS])
		CP="${CP} --verbose"
	;;
	*)
	continue
	;;
esac 

# copy files f'n, if a dir then copy recursive;
# if a file then just copy; otherwise exit.
copy_files() {
	for file in $BKUP_FILES; do
		if [ -d $file ]; then 
			$CP -R $file $BKUP_DEST
		elif [ -f $file ]; then  
			$CP $file $BKUP_DEST	
		else 
			echo " * $file: File to be copied does not exist or is not a regular file or directory!"
			exit 1
		fi
		echo "    file copied: $file" 
	done
}

# make sure dest dir exists, if not then create and/or copy. 
if [ -d $BKUP_DEST ]; then
	echo " * Copying files to: $BKUP_DEST"
	copy_files
	echo ""
else
	echo " * Destination $BKUP_DEST does not exist! Creating..."
	mkdir -p $BKUP_DEST
	echo " * Copying files to: $BKUP_DEST"
	copy_files
	echo ""
fi
   
