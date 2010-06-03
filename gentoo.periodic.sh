#!/bin/bash
#
# gentoo.peroidic.sh - run scripts in given dirs. this is 
# designed to run out of crontab. 

# !! THIS MUST BE PRESENT AT THE TOP OF EACH SCRIPT MODULE !!
# source config file, before doing anything else
if [ -e /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf ]; then 
	source /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf 
else 
	echo "gentoo.periodic.sh: ERROR! Cannot source config file!"
	exit 1	
fi
# -------------------

# simple usage statement
output_usage() { cat << EOF
 Usage: generate-reports [global-option]
   Global Options:
    -c: run script
    -m: monthly
    -y: yearly
    -s: security
    -h: this help message
EOF
}

# this actually executes the script modules
run_script() {
	for script in $(ls -1 /usr/local/sbin/gentoo-periodic/$PERIOD | sort -n); do
		sh /usr/local/sbin/gentoo-periodic/$PERIOD/$script >> $TMP_FILE
	done
	# just so we know that we are done.
	echo "" >> $TMP_FILE
	echo "  *** Reporting Complete!" >> $TMP_FILE
	echo "" >> $TMP_FILE	
}

# option list and script runner handling. 
while getopts c:dmwysh OPT; do
	case "$OPT" in 
		c)      # run script manually 
			SCRIPT="$OPTARG"
			sh -x $SCRIPT 
			;;
		d)      # daily
			PERIOD="daily"
			run_script
			;;
		w)      # weekly
			PERIOD="weekly"
			run_script
			;;
		m)      # monthly
			PERIOD="monthly"
			run_script
			;;
		y)      # yearly
			PERIOD="yearly"
			run_script
			;;
		s)      # security
			PERIOD="security"
			run_script
			;;
		h)      # help
			output_usage
			;;
		*)      # everything else
			echo " gentoo.periodic.sh: ERROR! Option not valid!" 	
			output_usage
			;;
	esac
done

# mailout and housekeeping.
HOST=`hostname | tr [:lower:] [:upper:]`
if [[ -e $TMP_FILE ]]; then 
	# loop thru the email address list
	for eml in ${DST_EML}; do 
		mail -s "$HOST: $PERIOD report for $NOW" $eml < $TMP_FILE
	done

	rm -f $TMP_FILE
fi 
