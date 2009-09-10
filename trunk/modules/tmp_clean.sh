#!/bin/bash
#
# $Header: /home/drew/bin/projects/gentoo-periodic/modules/RCS/tmp_clean.sh,v 1.5 2009/09/09 18:44:17 drew Exp $
#
# tmp_clean.sh - clean out /tmp
#

# verbosity and file removal on/off
RM_FILES="no"
CHATTY="yes"
# dirs to look at 
TMP_ROOT="/tmp /var/tmp"
# number days to ignore, files to ignore
DAYS=3
IGNORE_NAMES="( -not -iname "X.*-lock" -o -not -iname "etc-update*" )"
# args for files
FILE_ARGS="-depth -type f"
FILE_ARGS="${FILE_ARGS} -atime +$DAYS -ctime +$DAYS -mtime +$DAYS"
# args for dirs
DIR_ARGS="-depth -empty -type d"
DIR_ARGS="${DIR_ARGS} -atime +$DAYS -ctime +$DAYS -mtime +$DAYS"

if [ -n "${IGNORE_NAMES}" ]; then 
	IGNORE_FILE_ARGS="${IGNORE_NAMES}"
	IGNORE_DIR_ARGS="${IGNORE_NAMES}"
fi

# determine if we are removing files
case "$RM_FILES" in 
	[yY][eE][sS])	
		REMOVE="-exec rm {} \;"
	;;
	[nN][oO])
		REMOVE=""
	;;
	*)
		echo " ERROR! Are we removing files?"
		echo ""
		exit 1
	;;
esac

# determine verbosicty
case "$CHATTY" in 
	[yY][eE][sS])
		VERBOSE="-print"   
	;;
	[nN][oO])
		VERBOSE=""
	;;
	*)
		echo " ERROR! Do you want verbose output?"
		echo ""
		exit 1
	;; 	
esac

# file searching/removal done here
for dir in $TMP_ROOT; do 
	if [ ."${dir#/}" != ."$dir" -a -d $dir ]; then 
		echo " * Searching for stale files in: $dir" 
		find $dir $FILE_ARGS $IGNORE_FILE_ARGS $REMOVE $VERBOSE 
		find $dir $DIR_ARGS $IGNORE_DIR_ARGS $REMOVE $VERBOSE
		echo ""
	fi
done			

