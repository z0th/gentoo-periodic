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

case "$external_ip_enable" in 
	[yY][eE][sS])	# get the external IP
		MY_PID="$$"

		# this page reports the ip, in plaintext.
		curl $external_ip_site --silent --connect-timeout 30 --output /tmp/$MY_PID.external_ip.tmp
		# just to make sure, scrape out any html from the output.
		MY_EXT_IP=$( sed -e :a -e 's/<[^>]*>//g;/</N;//ba' /tmp/$MY_PID.external_ip.tmp ) 
	
		# if the file exists
		if [[ -f /tmp/$MY_PID.external_ip.tmp ]]; then 
			
			# and if the var has value	
			if [[ -n $MY_EXT_IP ]]; then 
				
				# then generate output and rm the temp file 
				echo " * Current external IP address." 
				echo "   " $MY_EXT_IP
				echo ""
				
				if [[ -f /tmp/$MY_PID.external_ip.tmp ]]; then 
						rm /tmp/$MY_PID.external_ip.tmp
				fi
				
		
			else 
			
				echo " * error: MY_EXT_IP has no value"
				echo " * exiting!"
				exit 1
			
			fi 
		
		else 
	
			echo "$MY_PID.external_ip.tmp is missing." 
			exit 1

		fi 

	;;
	*)	# do nothing.
		echo "This should probably never be seen." 	
	;;
esac

exit 0

