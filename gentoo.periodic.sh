#!/bin/bash
#
# $Header: /usr/local/sbin/gentoo.periodic/RCS/gentoo.periodic.sh,v 1.7 2009/02/19 20:18:53 root Exp $
#
# gentoo.peroidic - run scripts in given dirs. this is 
# designed to run out of crontab. 

# base directory where gentoo.periodic is installed
BASE_DIR="/usr/local/sbin/gentoo.periodic"
DST_EML=""
NOW=$(date +%F)
# temp file to output to, exported to the shell
TMP_FILE="/tmp/$$.perioidic.tmp"
export TMP_FILE

# simple usage statement
output_usage() {
	echo " Usage: generate-reports [global-option]"
	echo " Global Options:"
	echo "   -c: run script"
	echo "   -d: daily"
	echo "   -w: weekly"
	echo "   -m: monthly"
	echo "   -y: yearly"
	echo "   -s: security"
	echo "   -h: this help message"
}

# this actually executes the script module 
run_script() {
	for script in `ls -1 $BASE_DIR/$PERIOD | sort -n`; do
		sh $BASE_DIR/$PERIOD/$script >> $TMP_FILE
	done
}

# option list and script runner handling. 
while getopts c:dmwysh OPT; do
	case "$OPT" in 
		c)	# run script manually 	
			SCRIPT="$OPTARG"
			sh -x $SCRIPT 
			;;
		d)	# daily
			PERIOD="daily"
			run_script
			;;
		w)	# weekly
			PERIOD="weekly"
			run_script
			;;
		m)	# monthly
			PERIOD="monthly"
			run_script
			;;
		y)	# yearly
			PERIOD="yearly"
			run_script
			;;
		s) 	# security
			PERIOD="security"
			run_script
			;;
		h)	# help
			output_usage
			;;
		*)	# everything else
			output_usage
			;;
	esac
done

# mailout and housekeeping.
HOST=`hostname | tr [:lower:] [:upper:]`
if [[ -e $TMP_FILE ]]; then 
	mail -s "$HOST: $PERIOD report for $NOW" $DST_EML < $TMP_FILE
	rm -f $TMP_FILE
fi 
