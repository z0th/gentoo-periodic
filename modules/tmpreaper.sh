#!/bin/bash

# TMPEAPER.SH - alternate method of removing files from temporary directories.

# !! THIS MUST BE PRESENT AT THE TOP OF EACH SCRIPT MODULE !!
# source config file, before doing anything else
if [ -r /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf ]; then 
	source /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf
else
	echo " $(basename $0): ERROR! Cannot source config file!"
	exit 1
fi
# -------------------

# locate tmpreaper on the system.
tmpreap=$(which tmpreaper)
if [ -z $tmpreap ]; then 
	echo " * tmpreaper is not installed!"
	echo " * Please install app-admin/tmpreaper!"
	echo "" 
	exit 1 
fi

# make sure something dumb isnt happening. 
# loading the targets into an array for individual checks.
target_check=( $target )
for dir in ${target_check[*]}; do 
	check=$(expr match "$dir" '^/$\|/bin\|/boot\|/dev\|/etc\|/lib\|/proc\|/sbin\|/sys\|/usr')
	if [ $check -gt 0 ]; then 
		echo " $(basename $0): ERROR! You should not be looking for temp files in $dir! Exiting." 
		echo ""
		exit 1 
	fi
done

# putting together the actual command based on given opts. 
case "$tmpreaper_enable" in
	[Yy][Ee][Ss])
		# verbosity 
		case "${tmpreaper_verbosity}" in
			[yY][eE][Ss])
				verbose="--verbose"
			;;
			*)
				verbose=
			;;
		esac
		# test only
		case "${tmpreaper_test_only}" in 
			[yY][eE][Ss])
				test="--test"
			;; 
			*)
				test=
			;; 
		esac
		# show removed? 
		case "${tmpreaper_show_rm}" in 
			[yY][eE][Ss])
				showrm="--showdeleted"
			;; 
			*)
				showrm= 
			;; 
		esac 
		# grace period
		if [ -n ${tmpreaper_grace_period} ]; then 
			grace=${tmpreaper_grace_period}
		else
			echo " $(basename $0): ERROR! Setting of tmpreaper_grace_period mandatory! Exiting!"
			exit 1 
		fi
		# max run time	
		if [ -n ${tmpreaper_max_run} ]; then 
			runtime="--runtime=$tmpreaper_max_run"
		else 
			runtime=
		fi
		# file type protection	
		if [ -n "${tmpreaper_protect_files}" ]; then 
			for expr in $protect_files; do 
				protect="${protect} --protect $expr"
			done
		else 
			protect=
		fi

		# executing tmpreaper command, with flags 
		echo " * Tmpreaper is checking for stale files in $tmpreaper_target..."
		$tmpreap $verbose $test $showrm $runtime $protect $grace $tmpreaper_target 	
		echo ""
	;;

	*)
		# disabled, or broken
		echo " $(basename $0): ERROR! tempreaper_enable is set to NO or invalid option!"
		echo "" 
		exit 1
	;;
esac

