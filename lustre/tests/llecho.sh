#!/bin/sh

SRCDIR="`dirname $0`"
. $SRCDIR/common.sh

setup

$R/usr/src/portals/linux/utils/ptlctl <<EOF
mynid localhost
setup tcp
connect localhost 1234
add_uuid self
add_uuid ost
quit
EOF

mknod /dev/obd c 10 241
echo 8191 > /proc/sys/portals/debug
echo 8191 > /proc/sys/portals/trace

$R/usr/src/obd/utils/obdctl <<EOF
device 0
attach obdecho
setup
device 1
attach ost
setup 0
device 2
attach osc
setup -1
quit
EOF

cat <<EOF
run getattr tests as:
obdctl 
device 2 
connect
test_getattr 1000000
EOF
