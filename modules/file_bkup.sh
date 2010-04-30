#!/bin/bash

# $Header: /home/drew/bin/projects/modules/RCS/file_bkup.sh,v 1.1 2009/09/09 20:02:01 drew Exp $

# file_bkup.sh - back up critical system files and directories.

# !! THIS MUST BE PRESENT AT THE TOP OF EACH SCRIPT MODULE !!
source_config() {
my_name=$(basename $0)
my_conf=$(find .. -name 'gentoo.periodic.conf')
if [[ -n $my_conf ]]; then
        source $my_conf
else 
	echo " * ERROR:" $my_name ": cannot source config!"
	exit 0
fi
}
source_config
# -------------------



# default files to back up.
DEF_BKUP="/etc/crontab /etc/fstab /etc/group /etc/gshadow /etc/passwd /etc/shadow"
# cating vars together 
BKUP_FILES="${DEF_BKUP} ${OPT_BKUP}"

case ${FILE_BKUP_VERBOSE} in 
	[yY][eE][sS])
		CP="${FILE_BKUP_CP} --verbose"
	;;
	*)
		CP=${FILE_BKUP_CP}	
		continue
	;;
esac 

# copy files f'n, if a dir then copy recursive;
# if a file then just copy; otherwise exit.
copy_files() {
	for file in $BKUP_FILES; do
		if [ -d $file ]; then 
			$CP -R $file $BKUP_DEST
			echo "   directory copied: $file"
		elif [ -f $file ]; then  
			$CP $file $BKUP_DEST
			echo "   file copied: $file"
		else 
			echo "   ERROR! $file: File to be copied does not exist or is not a regular file or directory!"
		fi
	done
}

# make sure dest dir exists, if not then create and/or copy. 
echo " * Backing up critical files and directories."
if [ -d $FILE_BKUP_DEST ]; then
	echo " * Destination $FILE_BKUP_DEST found!" 
	copy_files
	echo ""
else
	echo " * Destination $FILE_BKUP_DEST does not exist! Creating..."
	mkdir -p $FILE_BKUP_DEST
	copy_files
	echo ""
fi
   
