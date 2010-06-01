#!/bin/bash
# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/external_ip.sh,v 1.1 2008/12/24 13:59:19 root Exp $ 
#
# external_ip.sh - get and report the external ip address of a host.
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

MY_PID=$$

# this page reports the ip, in plaintext.
curl $external_ip_site --silent --output /tmp/$MY_PID.external_ip.tmp
# just to make sure, scrape out any html from the output.
MY_EXT_IP=$($external_ip_post-process_cmd) 

# rm the temp file
if [[ -f /tmp/$MY_PID.external_ip.tmp ]]; then 
	rm /tmp/$MY_PID.external_ip.tmp
fi

# generate some output.
echo " * Current external IP address." 
echo "    $MY_EXT_IP"
echo ""

