#!/bin/bash
#
# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/iptables_status.sh,v 1.3 2008/06/07 20:55:48 root Exp $
#
# iptables-status.sh - output iptables current status
#

IPT=`which iptables` 

if [[ -n $IPT ]]; then 
	echo " * Current state of the firewall."
	$IPT --list --numeric --verbose
	echo "" 
else 
	echo " * NOTICE: iptables not installed!"
	echo ""
fi
