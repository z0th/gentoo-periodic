#!/bin/bash
# 
# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/glsa_check.sh,v 1.4 2008/06/07 17:32:27 root Exp $
# 
# glsa-check.sh - check for security issues
#
glsa_cmd() { 
	glsa-check -n --list affected 2>&1 
}

echo " * Checking for local security issues..."
glsa_cmd  
echo ""

