#! /bin/bash

# TMP_CLEAN.SH - display/clean files out of temporary directories.

# if enabled, then do stuff, otherwise do nothing.
ENABLE=yes
# file removal, verbosity, and pruning control 
REMOVE=no
VERBOSE=yes
PRUNED=no
# directories to search for stale files. before listing the many
# temp directories here, it would be wise to read the Filesystem
# Higharcy Standard at http://www.pathname.com/fhs/
SEARCH_DIRS="/tmp"
# how many days in the past to sart looking. 
# this default value is to prevent accidental removal of critical files.
DAYS=400
# ignore files named... 
IGNORE_NAMES=".X*-lock quota.user quota.group"
# dont dip down into dirs named...
# NOTE: this is a find regex and must match the
# entire path!
PRUNE_REGEX="*/lock|/etc-update-.*"

case "$ENABLE" in
	# we are enabled.
	[Yy][Ee][Ss])
		if [[ -z ${SEARCH_DIRS} ]]; then

			# check and make sure settings are present.
			echo " * You must set the "SEARCH_DIRS" variable!"
			exit 1
			if [ -z $DAYS ]; then 
				echo " * You must set the "DAYS" variable!"
			fi
			exit 1

		else 

			# set up find arguments	
			FIND_ARGS="-atime +$DAYS -mtime +$DAYS -ctime +$DAYS"
			DIR_ARGS="-empty -mtime +$DAYS"

			if [ -n "$IGNORE_NAMES" ]; then {
				FIND_ARGS="${FIND_ARGS} "`echo " ${IGNORE_NAMES% }" | \
				 sed 's/[    ][      ]*/ -not -name /g'`
				DIR_ARGS="${DIR_ARGS} "`echo " ${IGNORE_NAMES% }" | \
				 sed 's/[    ][      ]*/ -not -name /g'`
				}
			fi

			# are we pruning?
			case "$PRUNED" in 
				[Yy][Ee][Ss])
					PRUNE="( ! -regex '${PRUNE_REGEX}' ) -prune"
				;;
				*)
					PRUNE=
				;;
			esac

			# are we removing files? 	
			case "$REMOVE" in 
				[Yy][Ee][Ss])
					RM="-delete"
				;;
				*)
					RM=
				;;
			esac
		
			# run in verbose mode? 	
			case "$VERBOSE" in 
				[Yy][Ee][Ss])
					PRINT="-print" 
				;;
				*)
					PRINT=
				;;
			esac
			
			# search for stale files. 	
			echo " * Temp Direcotry Clean-up"
			echo " * File removal is set to: $(echo $REMOVE|tr [:lower:] [:upper:])"
	
			for dir in $SEARCH_DIRS; do 
				if [ ."${dir#/}" != ."$dir" -a -d $dir ]; then 
					cd $dir
					echo " * Searching $dir for stale files more than $DAYS days old..." 
					find . -type f $PRUNE $FIND_ARGS $RM $PRINT
					echo "" 
					echo " * Searching $dir for stale directories more than $DAYS days old..." 
					find . -not -name . -type d $PRUNE $DIR_ARGS $RM $PRINT
					echo "" 
				fi 
			done
	
		fi 
	;;
	*)
		# we are disabled, or broken.  	
		echo " * ENABLED is set to NO or invalid option."
		echo " * No cleaning of temporary directories preformed!"
		echo ""
		exit 1
	;;
esac

