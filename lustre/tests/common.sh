if [ -d /r ]; then
  R=/r
fi

if [ -b /dev/loop0 ]; then
  LOOP=/dev/loop
else
  if [ -b /dev/loop/0 ]; then
    LOOP=/dev/loop/
  else
    echo "Cannot find /dev/loop0 or /dev/loop/0";
    exit -1
  fi
fi

setup() {
    mknod /dev/portals c 10 240

    insmod $R/usr/src/portals/linux/oslib/portals.o || exit -1
    insmod $R/usr/src/portals/linux/socknal/ksocknal.o || exit -1

    $R/usr/src/portals/linux/utils/acceptor 1234 &

    insmod $R/usr/src/obd/class/obdclass.o || exit -1
    insmod $R/usr/src/obd/rpc/ptlrpc.o || exit -1
    insmod $R/usr/src/obd/ext2obd/obdext2.o || exit -1
    insmod $R/usr/src/obd/ost/ost.o || exit -1
    insmod $R/usr/src/obd/osc/osc.o || exit -1
    insmod $R/usr/src/obd/obdecho/obdecho.o || exit -1
    insmod $R/usr/src/obd/mds/mds.o || exit -1
    insmod $R/usr/src/obd/mdc/mdc.o || exit -1
    insmod $R/usr/src/obd/llight/llight.o || exit -1

    $R/usr/src/portals/linux/utils/debugctl modules > $R/tmp/ogdb
    echo "The GDB module script is in /tmp/ogdb.  Press enter to continue"
    read
}
