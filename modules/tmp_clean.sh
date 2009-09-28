#! /bin/bash
# remove files? be verbose? 
REMOVE=no
VERBOSE=yes
PRUNED=yes
# look at dirs? how many days old? 
SEARCH_DIRS="/var/tmp"
DAYS=400
# ignore files and dirs named... 
IGNORE_NAMES=".X*-lock quota.user quota.group"
# dont dip down into dirs named...
# NOTE: this is a find regex and must match the
# entire path!
PRUNE_REGEX="/lock\|/etc-update-.*"
# if enabled, then do stuff, otherwise do nothing.
ENABLE=yes

case "$ENABLE" in
	[Yy][Ee][Ss])
		if [ -z $SEARCH_DIRS ]; then
			echo " * You must set the "SEARCH_DIRS" variable!"
			if [ -z $DAYS ]; then 
				echo " * You must set the "DAYS" variable!"
			fi
			exit 1

		else 
	
			FIND_ARGS="-atime +$DAYS -mtime +$DAYS -ctime +$DAYS"
			DIR_ARGS="-empty -mtime +$DAYS"

			if [ -n "$IGNORE_NAMES" ]; then {
				FIND_ARGS="${FIND_ARGS} "`echo " ${IGNORE_NAMES% }" | \
				 sed 's/[    ][      ]*/ -not -name /g'`
				DIR_ARGS="${DIR_ARGS} "`echo " ${IGNORE_NAMES% }" | \
				 sed 's/[    ][      ]*/ -not -name /g'`
				}
			fi


			case "$PRUNED" in 
				[Yy][Ee][Ss])
					PRUNE="( ! -regex '${PRUNE_REGEX} ) -prune"
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
			
			for dir in $SEARCH_DIRS; do 
				if [ ."${dir#/}" != ."$dir" -a -d $dir ]; then 
					cd $dir
					echo " * File removal is set to: $(echo $REMOVE|tr [:lower:] [:upper:])"
					echo " * Searching $dir for stale files more than $DAYS days old..." 
					find . -depth -type f $FIND_ARGS $RM $PRINT
					echo "" 
					echo " * Searching $dir for stale directories more than $DAYS days old..." 
					find . -not -name . -type d $PRUNE $DIR_ARGS $RM $PRINT
					echo "" 
				fi 
			done
	
		fi 
	;;
	*)
		echo " * ENABLED is set to NO."
		echo " * No cleaning of temporary directories preformed!"
		echo ""
		exit 1
	;;
esac

