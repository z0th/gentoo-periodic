#!/bin/bash
#
# accounting.sh - generat monthly login accounting stats

# !! THIS MUST BE PRESENT AT THE TOP OF EACH SCRIPT MODULE !!
# source config file, before doing anything else
if [ -r /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf ]; then 
        source /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf
else
        echo " $(basename $0): ERROR! Cannot source config file!"
        exit 1
fi
# -------------------

accounting() {
# get per user login totals
case $user_totals in
        [yY][eE][Ss]) # print user totals
                echo " * Total logins per user"
                /usr/bin/ac --individual-totals
                echo "" 
                ;;
        *) # do nothing
                echo " * Per user login accounting not shown"
                ;; 
esac
# get daily login totals
case $daily_totals in 
        [yY][eE][Ss]) # print daily totals
                echo " * Total logins per day"
                /usr/bin/ac --daily-totals
                echo "" 
                ;;
        *) # do nothing
                echo " * Daily total login accounting not shown"
                ;;
esac
# always show the total per month
total_logins=$(/usr/bin/ac|awk '{print $2}')
echo " * Total logins for the month of $(date +%b)"
echo $total_logins
echo ""
}

# execute things, need 'ac' to run
if [ -x /usr/bin/ac ]; then 
		# do accounting
        accounting
        exit 0
else 
        #print warning
        echo " * /usr/bin/ac does not exist!"
        echo " * You need to install sys-process/acct"
        exit 1
fi