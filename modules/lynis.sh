#!/bin/bash
#
# $Header$
#
# rkhunter-lynis.sh - check for presence of rootkits on the system.
# lynis has supplanted/branched from rkhunter.
#

# !! THIS MUST BE PRESENT AT THE TOP OF EACH SCRIPT MODULE !!
# source config file, before doing anything else
if [ -r /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf ]; then 
	source /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf
else
	echo " $(basename $0): ERROR! Cannot source config file!"
	exit 1
fi
# -------------------

LYNIS=$( which lynis )
# dat file is always here
DAT="/var/log/lynis-report.dat"

run_lynis(){
	$LYNIS update info --cronjob --quiet --no-colors --logfile ${lynis_log_dir}/${lynis_log_file} && \ 
	$LYNIS audit system --cronjob --quiet --no-colors --logfile ${lynis_log_dir}/${lynis_log_file} 
}

# a couple of simple checks
checks() {
	# if not installed
	if [[ -z $LYNIS ]]; then echo " * lynis is not installed!"
		echo " * Please install app-forensics/lynis"
		echo " * Exiting."
		echo ""
		exit 1 
	fi

	# create the log dir/file if missing
	if [[ ! -e $lynis_log_dir ]]; then
		mkdir $lynis_log_dir
	fi
	if [[ ! -e $lynis_log_dir/$lynis_log_file ]]; then 
		touch $lynis_log_dir/$lynis_log_file
	fi
	if [[ ! -w $lynis_log_dir/$lynis_log_file ]]; then 
		chmod u+w $lynis_log_dir/$lynis_log_file
	fi
}

case $lynis_enable in
[yY][eE][sS]) # do checks, run lynis 
		# run checks, exit upon error
		checks
		# run lynis, check for dat
		if [[ -e $DAT ]]; then
			echo " * Running lynis."
			run_lynis
			echo " * Lynis run complete! See the log for details."
			echo " *" ${lynis_log_dir}/${lynis_log_file} 
			echo "" 
		else
			# dat file missing.
			echo " * Lynis DAT file missing at $DAT"  
			echo " * Exiting."
			exit 1
		fi
		;;
	*) # do nothing
		echo " * Not running lynis checks"
		;; 
esac

exit 0 

