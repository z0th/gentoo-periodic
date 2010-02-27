#!/bin/bash
#
# gentoo.peroidic.sh - run scripts in given dirs. this is 
# designed to run out of crontab. 

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

# this actually executes the script modules
run_script() {
	for script in `ls -1 $BASE_DIR/$PERIOD | sort -n`; do
		sh $SCRIPTPATH/$PERIOD/$script >> $TMP_FILE
	done
	# just so we know that we are done.
	echo "" >> $TMP_FILE
	echo "  *** Reporting Complete!" >> $TMP_FILE
	echo "" >> $TMP_FILE	
}

# base directory where gentoo.periodic is installed, EXPORT.
self_ref() {
        # full path to this script.
        SCRIPT=$(readlink -f $0)
        # path to install dir.
        SCRIPTPATH=`dirname $SCRIPT`
        export SCRIPT 
        export SCRIPTPATH
}

# LOCAL VARIABLES! 
# NOTE: some of these will need to be pulled out and sourced
# from a .conf file [$BASE_DIR/gentoo-periodic.conf]. 
#
# base directory where gentoo.periodic is installed, LOCAL.
BASE_DIR=$(readlink -f $0|xargs dirname)
#BASE_DIR="/usr/local/sbin/gentoo.periodic"
# destination email address
DST_EML=""
# todays date
NOW=$(date +%F)
# temp file to output to, exported to the shell
TMP_FILE="/tmp/$$.perioidic.tmp"
export TMP_FILE

# option list and script runner handling. 
while getopts c:dmwysh OPT; do
        case "$OPT" in 
                c)      # run script manually 
                        SCRIPT="$OPTARG"
                        sh -x $SCRIPT 
                        ;;
                d)      # daily
                        PERIOD="daily"
                        self_ref
                        run_script
                        ;;
                w)      # weekly
                        PERIOD="weekly"
                        self_ref
                        run_script
                        ;;
                m)      # monthly
                        PERIOD="monthly"
                        self_ref
                        run_script
                        ;;
                y)      # yearly
                        PERIOD="yearly"
                        self_ref
                        run_script
                        ;;
                s)      # security
                        PERIOD="security"
                        self_ref
                        run_script
                        ;;
                h)      # help
                        output_usage
                        ;;
                *)      # everything else
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
