#!/bin/bash 

# 
# check to see that /etc/crontab has the PROPER permissions: 0644 || -rw-r--r-- 

# !! THIS MUST BE PRESENT AT THE TOP OF EACH SCRIPT MODULE !!
# source config file, before doing anything else
if [ -r /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf ]; then 
	source /usr/local/sbin/gentoo-periodic/gentoo.periodic.conf
else
	echo " $(basename $0): ERROR! Cannot source config file!"
	exit 1
fi
# -------------------

change_crontab_perms() {
        chown root:root ${sys_cron}
        chmod 644 ${sys_cron}
}

# check crontab perms, 
perms=$(stat --format="%a %u %g" ${sys_cron})

if [[ ${perms} != '644 0 0' ]]; then 
        # perms are broken
        echo " * Problem with ${sys_cron} detected!" 
        change_crontab_perms
        echo " * Owner, group and file mode corrected"
        exit 1
else
        # perms are fine
        echo " * Permissions on system crontab ${sys_cron} checked."
        echo " * No problems found."
        exit 0
fi