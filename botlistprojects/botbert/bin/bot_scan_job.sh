#!/bin/sh

# Depending on if we are running from pwd or not, determine
# proper location to change directory to.
case $0 in 
	/*) 
		ABS_APP_PATH=$0
		ABS_CONF=`dirname $ABS_APP_PATH`
		ABS_CONF=`dirname $ABS_CONF`
		;;
	bin*)
		ABS_APP_PATH=`pwd`
		ABS_CONF=$ABS_APP_PATH
		;;
	*) 
		ABS_APP_PATH=`pwd`
		ABS_CONF=`dirname $ABS_APP_PATH`
		;; 
esac

BOTBERT_HOME=$ABS_CONF
TOPDIR=$BOTBERT_HOME
DIR_PROPERTIES=$BOTBERT_HOME

if [ $(uname -s | grep -c CYGWIN) -gt 0 ]; then
	echo "WARN: running in CYGWIN environment"
	DIR_PROPERTIES=`cygpath -wp $BOTBERT_HOME`
else
	CPBOTBERT=$LIN_CPBOTBERT
fi

cd $BOTBERT_HOME

APP_PROC_CHK=${BOTBERT_HOME}/lib/python/check_process.py
python $APP_PROC_CHK $BOTBERT_HOME/bin/botbert.pid botlist_scan_feeds.py $@
# Use '$?' to check the last value returned
LAST_EXIT_CODE=$?
if [ "$LAST_EXIT_CODE" -eq "255" ] ; then
	# We shouldn't have gotten to this point.  Something is really wrong.
	echo "Invalid exit code, check_process.py" ;
	exit 1
elif [ "$LAST_EXIT_CODE" -ne "0" ] ; then
	echo "ERR: Scan proces is still running, exiting. ($LAST_EXIT_CODE)" ;
	exit 1
fi

APP_MAIN=${BOTBERT_HOME}/lib/python/botlist_scan_feeds.py
echo "running in directory=${BOTBERT_HOME}"
echo "-----------------------"

python $APP_MAIN -f $DIR_PROPERTIES $@ &

# Write the process id
echo $! > $BOTBERT_HOME/bin/botbert.pid

# End of Script
