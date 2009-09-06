# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/ssh_login.sh,v 1.3 2008/06/09 13:11:53 root Exp $
#
# ssh_login.sh - find unsuccessful and successful logins 

AUTH_LOGS="/var/log/auth.log /var/log/auth.log.0"
TODAY=`date --date=yesterday "+%b %_d"`
TMP_FILE="/tmp/$$.login_check.tmp"

cat $AUTH_LOGS | fgrep "$TODAY" > $TMP_FILE 

# find successful logins
echo " * Sucessful logins." 
fgrep "Accepted keyboard-interactive" $TMP_FILE
echo ""
# find all good suid attempts
echo " * Sucessful SUID logins."
fgrep "Successful su for root by " $TMP_FILE 
echo "" 
# find unsuccessful logins
echo " * Unucessful attempted logins." 
fgrep "Invalid user " $TMP_FILE
echo "" 
# find all bad suid attempts
echo " * Unsucessful SUID attempts." 
fgrep "FAILED su for" $TMP_FILE
echo ""

# find possible sshd scanners
echo " * Possible sshd scanners" 
fgrep "POSSIBLE BREAK-IN ATTEMPT!" $TMP_FILE 
echo ""

if [[ -e $TMP_FILE ]]; then 
	rm $TMP_FILE
fi

