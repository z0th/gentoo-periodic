#!/bin/bash

# $Header: /home/drew/bin/projects/modules/RCS/file_bkup.sh,v 1.1 2009/09/09 20:02:01 drew Exp $

# file_bkup.sh - back up critical system files.

# default files to be backed up
def_bkup="/etc/passwd /etc/group /etc/shadow /etc/gshadow"
# optional files to be backed up
opt_bkup="/etc/hosts /etc/make.conf"
# backup destination
BKUP_DEST="/etc/backups"
#
BKUP_FILES="${def_bkup} ${opt_bkup}"

# copy files f'n, if a dir then copy recursive
# if a file then just copy, otherwise break.
copy_files() {
	for file in $BKUP_FILES; do
		echo "   file copied: $file" 
		if [ -d $file ]; then 
			cp -R $file $BKUP_DEST
		elif [ -f $file ] 
			cp $file 	
		else 
			   echo " * ERROR! File to be copied does not exist or is not a regular file or directory!"
			   exit 1
		fi	   
	done
}

# make sure dest dir exists.
if [ -d $BKUP_DEST ]; then
	echo " * Copying system files to: $BKUP_DEST"
	copy_files
else
	 echo " * Destionation does not exist! Creating..."
	 echo " * Copying system files to: $BKUP_DEST"
	 copy_files
fi
	   



