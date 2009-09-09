#!/bin/bash

# $Header$

# file_bkup.sh - back up critical system files.

# default files to be backed up
def_bkup_files="/etc/passwd /etc/group /etc/shadow /etc/gshadow"
# optional files to be backed up
opt_bkup_files="/etc/hosts"
# backup destination
bkup_dest="/etc"

bkup_files=`echo $def_bkup_files $opt_bkup_files`



