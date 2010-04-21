#!/bin/bash

# $Header: /home/drew/bin/projects/modules/RCS/file_bkup.sh,v 1.1 2009/09/09 20:02:01 drew Exp $

# file_bkup.sh - back up critical system files and directories.

# ----------------
# this code sources the config file! must be at the top of every module! 
my_name=$(basename $0)
# source config
if [ -e $INSTALL_DIR/gentoo.periodic.conf ]; then
	. $INSTALL_DIR/gentoo.periodic.conf 
else 
	echo " * ERROR:" $my_name ": cannot source config!"
	exit 0
fi
# ----------------

# cating vars together 
BKUP_FILES="${DEF_BKUP} ${OPT_BKUP}"

case ${FILE_BKUP_VERBOSE} in 
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
   
