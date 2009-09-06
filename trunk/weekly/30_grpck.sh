# $Header: /usr/local/sbin/gentoo.periodic/modules/RCS/grpck.sh,v 1.1 2008/11/21 15:09:37 root Exp $
#
# grpck.sh - check for unused groups.
#
GRPFILE="/etc/group"

echo " * Checking for unused groups..."
/usr/sbin/grpck -r $GRPFILE
echo ""

