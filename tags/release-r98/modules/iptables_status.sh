#!/bin/bash
#
# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/iptables_status.sh,v 1.3 2008/06/07 20:55:48 root Exp $
#
# iptables-status.sh - output iptables current status
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

IPT=$(which iptables) 

if [[ -n $IPT ]]; then 
	echo " * Current state of the firewall."
	$IPT --list --numeric --verbose
	echo "" 
else 
	echo " * NOTICE: iptables not installed!"
	echo ""
fi
