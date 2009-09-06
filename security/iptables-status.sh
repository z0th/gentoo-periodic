#!/bin/bash
#
# $Header$
#
# iptables-status.sh - output iptables current status
#
IPTABLES=`which iptables`
$IPTABLES --list --numeric --verbose 
