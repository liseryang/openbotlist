#!/bin/sh

# bot remote sync.sh
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
if [ -z "$JAVA_HOME"  ] ; then
 JAVA_HOME=/usr
fi

JAVA=$JAVA_HOME/bin/java

BOTBERT_HOME=$ABS_CONF
# The botlist projects directory contains the system library (jruby)
PROJECTS_HOME=`dirname $BOTBERT_HOME`
TOPDIR=$BOTBERT_HOME

# Use the top project directory to include the correct CP config functions
. ${TOPDIR}/bin/conf_remote_funcs.sh


cd $BOTBERT_HOME

echo "-----------------------"
echo "running in directory=${BOTBERT_HOME}"
echo $LIN_CPBOTBERT
echo "-----------------------"

# Append '&' to run in background
# Append -Xmx32M heap settings if needed
URL1="http://botspiritcompany.com/botlist/lift/pipes/types/remote_agent_req"
URL2="http://botspiritcompany.com/botlist/lift/pipes/types/remote_agent_send"
"$JAVA" -classpath $LIN_CPBOTBERT $APP_MAIN ruby/bot_remote_sync.rb ${URL1} ${URL2} $@

# Write the process id
echo $! > $BOTBERT_HOME/bin/botremotesync.pid

# End of Script --
