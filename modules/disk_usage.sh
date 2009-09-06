#!/bin/bash
#
# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/disk_usage.sh,v 1.3 2008/04/02 14:36:07 root Exp $
#
# disk_usage.sh - output disk usage.
#
echo " * Current disk usage, all devices."
df --all --human-readable
echo ""
