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
		REMOVE_ARGS="-exec rm {} \;"
		TF_RM="true"
	;;
	[nN][oO])
		REMOVE_ARGS=""
		TF_RM="false"
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
		VERBOSE_ARGS="-print"  
		TF_INFO="true"
	;;
	[nN][oO])
		VERBOSE_ARGS=""
		TF_INFO="false"
	;;
	*)
		echo " ERROR! Do you want verbose output?"
		echo ""
		exit 1
	;; 	
esac

# so we have four conditionss, one function for each.
# the noremove_quiet is completely redundant, but included
# for sanity purposes.
remove_verbose() {
	find $dir $FILE_ARGS $IGNORE_FILE_ARGS $VERBOSE
	find $dir $DIR_ARGS $IGNORE_DIR_ARGS $VERBOSE
} 

remove_quiet() {
	find $dir $FILE_ARGS $IGNORE_FILE_ARGS $REMOVE_ARGS 2>&1 >/dev/null
	find $dir $DIR_ARGS $IGNORE_DIR_ARGS $REMOVE_ARGS 2>&1 >/dev/null 
}

noremove_verbose() {
	find $dir $FILE_ARGS $IGNORE_FILE_ARGS $VERBOSE_ARGS	
	find $dir $DIR_ARGS $IGNORE_DIR_ARGS $VERBOSE_ARGS
}

noremove_quiet() {
	find $dir $FILE_ARGS $IGNORE_FILE_ARGS $VERBOSE_ARGS 2>&1 >/dev/null 
	find $dir $DIR_ARGS $IGNORE_DIR_ARGS 2>&1 >/dev/null
} 

# file searching/removal done here

for dir in $TMP_ROOT; do 
	if [ ."${dir#/}" != ."$dir" -a -d $dir ]; then
		
		if [ $TF_RM = "true" ] && [ $TF_INFO = "true" ]; then
			echo " * Removing files in: $dir (verbose:ON)"
			remove_verbose
		elif [ $TF_RM = "true" ] && [ $TF_INFO = "false" ]; then 
			echo " * Removing files in: $dir (verbose:OFF)"
			remove_quiet
		elif [ $TF_RM = "false" ] && [ $TF_INFO = "true" ]; then
			echo " * Searching for stale files in: $dir (verbose:ON)"
			noremove_verbose
		elif [ $TF_RM = "false" ] && [ $TF_INFO = "false" ]; then
			echo " * No file removal with no verbosity is redundant!"
		else
			" * Error! Unanticipated options chosen!"
			exit 1
		fi 
	
		echo "" 
	fi
done
