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
TOPDIR=$BOTBERT_HOME
DIR_PROPERTIES=$BOTBERT_HOME

LIB1=$BOTBERT_HOME/lib/botlistloadtest.jar
LIB2=$BOTBERT_HOME/lib/jruby.jar
LIB3=$BOTBERT_HOME/lib/ibatis-2.3.0.677.jar
LIB4=$BOTBERT_HOME/lib/botlistbeans.jar
LIB5=$BOTBERT_HOME/lib/mysql-connector-java-5.0.3-bin.jar
LIB6=$BOTBERT_HOME/lib/botlist_searchutil.jar
LIB7=$BOTBERT_HOME/lib/lucene-core-2.1.0.jar

if [ $(uname -s | grep -c CYGWIN) -gt 0 ]; then
	echo "WARN: running in CYGWIN environment"
	DIR_PROPERTIES=`cygpath -wp $BOTBERT_HOME`
fi

LIN_CPBOTBERT=".:$LIB1:$LIB2:$LIB3:$LIB4:$LIB5:$LIB6:$LIB7"

cd $BOTBERT_HOME

APP_MAIN=org.jruby.Main
echo "running in directory=${BOTBERT_HOME}"
echo $LIN_CPBOTBERT
echo "-----------------------"

# Append '&' to run in background
# Append -Xmx32M heap settings if needed
TOP_DIR="/opt/tomcat5/webapps/botlist_search/WEB-INF/index_home"
"$JAVA" -Xms32M -Xmx128M -classpath $LIN_CPBOTBERT $APP_MAIN ruby/bot_index_search.rb ${TOP_DIR} $@

# Write the process id
echo $! > $BOTBERT_HOME/bin/botsearch.pid

# Revert index directory settings to proper tomcat owner
chown -R tomcat ${TOP_DIR}
chgrp -R tomcat ${TOP_DIR}

# End of Script --
