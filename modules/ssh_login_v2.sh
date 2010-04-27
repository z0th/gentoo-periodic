# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/ssh_login.sh,v 1.3 2008/06/09 13:11:53 root Exp $
#
# ssh_login.sh - find unsuccessful and successful logins 

my_name=$(basename $0)
# source config
if [ -e $INSTALL_DIR/gentoo.periodic.conf ]; then
	. $INSTALL_DIR/gentoo.periodic.conf 
else 
	echo " * ERROR:" $my_name ": cannot source config!"
	exit 0
fi

# verbose? summarize? 
#SSH_SUMMARY="YES"
# path to auth log
#SSH_AUTH_LOGS="/var/log/auth.log /var/log/auth.log.0"

# date and temp file 
SSH_TODAY=`date --date=yesterday "+%b %_d"`
SSH_TMP_FILE="/tmp/$$.login_check.tmp"
SSH_CNT_FILE="/tmp/$$.count_file.tmp"

# dump source into temp file
cat $SSH_AUTH_LOGS | fgrep "$SSH_TODAY" > $SSH_TMP_FILE 

sortip () { sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4; }

ssh_badauth_remote_summary() {
# possible ssh scanners
echo " * Unsuccessful attempted logins."
echo " * NOTE: null (missing) login names will be visible here!"
fgrep "Invalid user " $SSH_TMP_FILE | awk '{if (NF==10) print $10; else print $9}' > $SSH_CNT_FILE
fgrep "POSSIBLE BREAK-IN ATTEMPT" $SSH_TMP_FILE | grep -v "but this does not map back to the address" \
| awk '{print $12}' | sed 's/\[\|\]//g' >> $SSH_CNT_FILE
# there are two types of these BREAK IN lines
fgrep "POSSIBLE BREAK-IN ATTEMPT" $SSH_TMP_FILE | grep -v "reverse mapping checking getaddrinfo for" \
| awk '{print $7}' | sed 's/\[\|\]//g' >> $SSH_CNT_FILE
# bad logins seen by PAM
fgrep "error: PAM: Authentication failure for illegal user" $SSH_TMP_FILE | awk '{print $15}' >> $SSH_CNT_FILE 
# count them up
cat $SSH_CNT_FILE | sortip | uniq -c 
echo ""
#
# bad suids - have not found a good way to summarize these yet! 
echo " * Unsucessful PAM authenication attempts from valid users."
fgrep "error: PAM: Authentication failure for" $SSH_TMP_FILE | awk '{ if (NF==13) print $0 }'
echo ""
echo " * Unsucessful SUID attempts."
fgrep "FAILED su for" $SSH_TMP_FILE
echo ""
}

ssh_badauth_remote_verbose() {
# find unsuccessful logins
echo " * Unucessful attempted logins." 
fgrep "Invalid user " $SSH_TMP_FILE
echo "" 
# find possible sshd scanners
echo " * Possible sshd scanners" 
fgrep "POSSIBLE BREAK-IN ATTEMPT!" $SSH_TMP_FILE 
echo ""
# find all bad suid attempts
echo " * Unsucessful SUID attempts." 
fgrep "FAILED su for" $SSH_TMP_FILE
echo ""
# find bad logins from permitted users
echo "* Unsucessful logins from permitted users." 
fgrep "error: PAM: Authentication failure for" $SSH_TMP_FILE
}

ssh_goodauth_verbose() {
# find successful logins
echo " * Sucessful logins." 
fgrep "Accepted keyboard-interactive" $SSH_TMP_FILE
echo ""
# find all good suid attempts
echo " * Sucessful SUID logins."
fgrep "Successful su for root by " $SSH_TMP_FILE 
echo "" 
}

# call functions, if ssh_summary is yes, then summarize, otherwise verbose.
case $SSH_SUMMARY in 
	[yY][eE][sS])	
		ssh_badauth_remote_summary
		ssh_goodauth_verbose
	;;
	*)
		ssh_badauth_remote_verbose
		ssh_goodauth_verbose
	;;
esac

# remove temp files
if [[ -e $SSH_TMP_FILE ]]; then 
	rm $SSH_TMP_FILE
fi

if [[ -e $SSH_CNT_FILE ]]; then 
	rm $SSH_CNT_FILE
fi

# EOF
