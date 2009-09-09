#!/bin/bash
#
# $Header: /home/drew/bin/projects/gentoo-periodic/modules/RCS/tmp_clean.sh,v 1.3 2009/09/09 16:12:13 drew Exp $
#
# tmp_clean.sh - clean out /tmp
#

RM_FILES="no"
CHATTY="yes"

TMP_ROOT="/tmp /var/tmp"

DAYS=3
IGNORE_NAMES="X*-lock"

FILE_ARGS="-depth -type f"
FILE_ARGS="${FILE_ARGS} -atime +$DAYS -ctime +$DAYS -mtime $DAYS"

DIR_ARGS="-depth -empty -type d"
DIR_ARGS="${DIR_ARGS} -atime +$DAYS -ctime +$DAYS -mtime $DAYS"

if [ -n $IGNORE_NAMES ]; then 
	IGNORE_FILE_ARGS="! -name ${IGNORE_NAMES}"
	IGNORE_DIR_ARGS="! -name ${IGNORE_NAMES}"
fi

case "$RM_FILES" in 
	[yY][eE][sS])	
		REMOVE="-exec rm {} \;"
	;;
	[nN][oO])
		REMOVE=""
	;;
	*)
		echo " ERROR! Are we removing files?"
		exit 1
	;;
esac

case "$CHATTY" in 
	[yY][eE][sS])
		VERBOSE="-print"   
	;;
	[nN][oO])
		VERBOSE=""
	;;
	*)
		echo "ERROR! Do you want verbose output?"
		exit 1
	;; 	
esac

# file searching/removal done here
for dir in $TMP_ROOT; do 
	if [ ."${dir#/}" != ."$dir" -a -d $dir ]; then 
		find $dir $FILE_ARGS $IGNORE_FILE_ARGS $REMOVE $VERBOSE
		find $dir $DIR_ARGS $IGNORE_DIR_ARGS $REMOVE $VERBOSE
	fi
done			 
