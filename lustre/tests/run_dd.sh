#!/bin/bash
set -x

TMP=${TMP:-/tmp}

TESTSUITELOG=${TESTSUITELOG:-$TMP/recovery-mds-scale}
LOG=${TESTSUITELOG}_$(basename $0)-$(hostname)
DEBUGLOG=${LOG}.debug

mkdir -p ${LOG%/*}

rm -f $LOG $DEBUGLOG
exec 2>$DEBUGLOG

if [ -z "$MOUNT" -o -z "$END_RUN_FILE" -o -z "$LOAD_PID_FILE" ]; then
    echo "The following must be set: MOUNT END_RUN_FILE LOAD_PID_FILE"
    exit 1
fi

echoerr () { echo "$@" 1>&2 ; }

signaled() {
    echoerr "$(date +'%F %H:%M:%S'): client load was signaled to terminate"
    kill -TERM -$PPID
    sleep 5
    kill -KILL -$PPID
}

trap signaled TERM

# recovery-mds-scale uses this to signal the client loads to die
echo $$ >$LOAD_PID_FILE

TESTDIR=$MOUNT/dd-$(hostname)

CONTINUE=true
while [ ! -e "$END_RUN_FILE" ] && $CONTINUE; do
    echoerr "$(date +'%F %H:%M:%S'): dd run starting"
    mkdir -p $TESTDIR
    cd $TESTDIR
    dd bs=4k count=1000000 if=/dev/zero of=$TESTDIR/dd-file 1>$LOG &
    load_pid=$!
    wait $load_pid

    if [ $? -eq 0 ]; then
	echoerr "$(date +'%F %H:%M:%S'): dd succeeded"
	cd $TMP
	rm -rf $TESTDIR
	echoerr "$(date +'%F %H:%M:%S'): dd run finished"
    else
	echoerr "$(date +'%F %H:%M:%S'): dd failed"
	if [ -z "$ERRORS_OK" ]; then
	    echo $(hostname) >> $END_RUN_FILE
	fi
	if [ $BREAK_ON_ERROR ]; then
	    # break
            CONTINUE=false
	fi
    fi
done

echoerr "$(date +'%F %H:%M:%S'): dd run exiting"
