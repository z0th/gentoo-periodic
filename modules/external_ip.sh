#!/bin/bash
# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/external_ip.sh,v 1.1 2008/12/24 13:59:19 root Exp $ 
#
# external_ip.sh - get and report the external ip address of a host.
#

MY_PID=$$

# this page reports the ip, in plaintext.
curl http://whatismyip.com/automation/n09230945.asp --silent --output /tmp/$MY_PID.external_ip.tmp
# just to make sure, scrape out any html from the output.
MY_EXT_IP=$(cat /tmp/$MY_PID.external_ip.tmp | sed -e 's#<[^>]*>##g' | head -n1) 

# rm the temp file
if [[ -f /tmp/$MYPID.external_ip.tmp ]]; then 
	rm /tmp/$MYPID.external_ip.tmp
fi

# generate some output.
echo " * Current external IP address." 
echo "    $MY_EXT_IP"
echo ""

