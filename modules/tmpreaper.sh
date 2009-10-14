#!/bin/bash

# TMPEAPER.SH - alternate method of removing files from temporary directories.

# am i enabled? 
ENABLE="YES"

# target directories 
target="/tmp" 
# days old
grace_period=375d
# verbosity
verbosity=NO
# test only, do not remove files
test_only=YES
# show deleted files
show_rm=YES
# maximum runtime in seconds, 0-55, 0 to disable.
max_run=30
# protect files, this is a shell pattern.
protect_files=".X*-lock quota.user quota.group *.pid etc-update-*"

# locate tmpreaper on the system.
tmpreap=$(which tmpreaper)
if [ -z $tmpreap ]; then 
	echo " * tmpreaper is not installed!"
	echo " * Please install app-admin/tmpreaper!"
	echo "" 
	exit 1 
fi 
# make sure something dumb isnt happening.
if [ $target = / ]; then 
	echo " * You should not run this on the root directory!"
	exit 1
fi 
 
case "$ENABLE" in
	[Yy][Ee][Ss])
		# verbosity 
		case "${verbosity}" in
			[yY][eE][Ss])
				verbose="--verbose"
			;;
			*)
				verbose=
			;;
		esac
		# test only
		case "${test_only}" in 
			[yY][eE][Ss])
				test="--test"
			;; 
			*)
				test=
			;; 
		esac
		# show removed? 
		case "${show_rm}" in 
			[yY][eE][Ss])
				showrm="--showdeleted"
			;; 
			*)
				showrm= 
			;; 
		esac 
		# grace period
		if [ -n ${grace_period} ]; then 
			grace=${grace_period}
		else
			echo " * Setting of grace_period mandatory! Exiting!"
			exit 1 
		fi
		# max run time	
		if [ -n ${max_run} ]; then 
			runtime="--runtime=$max_run"
		else 
			runtime=
		fi
		# file type protection	
		if [ -n "${protect_files}" ]; then 
			for expr in $protect_files; do 
				protect="${protect} --protect $expr"
			done
		else 
			protect=
		fi

		# executing tmpreaper command, with flags 
		$tmpreap $verbose $test $showrm $runtime $protect $grace $target 	
	;;

	*)
		# disabled, or broken
		echo " * ENABLES is set to NO or invalid option."
		echo " * tmpreaper module did not execute."
	;;
esac

