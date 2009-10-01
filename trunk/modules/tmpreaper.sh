#!/bin/bash

# TMPEAPER.SH - alternate method of removing files from temporary directories.

# target directories 
tmp_dirs="/tmp /test" 
# days old
time_spec=375d
# verbosity
verbosity=NO
# test only, do not remove files
test_only=YES
# show deleted files
show_rm=YES
# maximum runtime in seconds, 0-55, 0 to disable.
max_run=30
# protect files, this is a shell pattern.
protect_files=".X*-lock quota.user quota.group *.pid etc-update-*"

# locate tmpreaper on the system.
tmpreap=$(which tmpreaper)

# before doing anything, make sure its installed.
if [ -z $tmpreap ]; then 
	echo " * tmpreaper is not installed!"
	echo " Please install app-admin/tmpreaper!"
	echo "" 
	exit 1 
fi 

# verbosity 
case "${verboxity}" in
	[yY][eE][Ss])
		verbose="--verbose"
	;;
	*)
		verbose=
	;;
esac

# test only
case "${test_only}" in 
	[yY][eE][Ss])
		test="--test"
	;; 
	*)
		test=
	;; 
esac

case "${show_rm}" in 
	[yY][eE][Ss])
		showrm="--showdeleted"
	;; 
	*)
		showrm= 
	;; 
esac 

if [ -n ${max_run} ]; then 
	runtime="--runtime=$max_run"
else 
	runtime=
fi

if [ -n $(time_spec)]; then 
	time=$time_spec
fi

