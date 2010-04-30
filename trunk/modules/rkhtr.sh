#!/bin/bash
#
# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/rkhtr.sh,v 1.5 2009/02/23 15:51:11 root Exp $
#
# rkhtr.sh - check for presence of rootkits on the system.
#

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

RKHTR=`which rkhunter`

run_rkhunter(){
	$RKHTR --quiet --nocolors --update && \
	$RKHTR --check --nocolors --skip-keypress --report-warnings-only
}

if [[ -z $RKHTR ]]; then 
   echo " * rkhunter is not installed!"
	echo " * Please install app-forensics/rkhunter"
	echo ""
else
	echo " * Updating and running rkhunter"
	if [ -f /var/lib/rkhunter/db/rkhunter.dat ]; then 
		# run rkhunter
		run_rkhunter	
	else
		# first run message, then run rkhunter	
		echo " ** If this is the first run of rkhunter, you will need to"
		echo " ** ensure your system is clean, then run 'rkhunter --proupd'"
		echo " ** to generate the rkhunter data file. You may also need to"
		echo " ** configure system spesific options in /etc/rkhunter.conf!" 
		run_rkunter			
	fi
	echo "" 
fi

