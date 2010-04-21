#!/bin/bash
#
# basic_sysinfo.sh - the basics of stuff you want to know.

# disk usage
disk_usage() {
echo " * Current disk usage, all devices."
df --all --human-readable
echo ""
}

# current user logins
current_logins() {
echo " * Users currently logged in."
w -f -s 
echo "" 
}

# interface stats
iface_stats() {
echo " * Interface statistics."
netstat -in
echo ""
}

# listening processes
listen_pids() {
echo " * Listening processes."
netstat --tcp --udp --program --listening --numeric-hosts --wide
echo ""
}

# running screens
running_screens() {
echo " * Currently running screen sessions."
ps ajx | fgrep SCREEN | grep -v "fgrep"
echo ""
}

# call various things.
disk_usage
current_logins
iface_stats
listen_pids
running_screens

