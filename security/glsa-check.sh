#!/bin/bash
# 
# $Header$
# 
# glsa-check.sh - check for security issues
#

glsa_cmd() { 
	glsa-check -n --list affected 
}

