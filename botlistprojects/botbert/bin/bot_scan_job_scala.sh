#!/bin/sh

BOTBERT_HOME=/home/bbrown/botlistprojects/botbert

if [ -z "$JAVA_HOME"  ] ; then
 JAVA_HOME=/usr
fi

JAVA=$JAVA_HOME/bin/java

LIB1=$BOTBERT_HOME/lib/scala-library.jar
LIB2=$BOTBERT_HOME/lib/scala-compilerjar

LIB3=$BOTBERT_HOME/lib/jdom.jar
LIB4=$BOTBERT_HOME/lib/mysql-connector-java-5.0.3-bin.jar
LIB5=$BOTBERT_HOME/lib/sbaz-tests.jar
LIB6=$BOTBERT_HOME/lib/scala-actors.jar
LIB7=$BOTBERT_HOME/lib/scala-dbc.jar
LIB8=$BOTBERT_HOME/lib/scala-decoder.jar
LIB9=$BOTBERT_HOME/lib/xercesImpl.jar
LIB_MAIN=$BOTBERT_HOME/build/botbert.jar

LIN_CPBOTBERT=".:$LIB1:$LIB2:$LIB3:$LIB4:$LIB5:$LIB6:$LIB7:$LIB8:$LIB9:$LIB_MAIN"

CPBOTBERT=$LIN_CPBOTVERT
DIR_PROPERTIES=$BOTBERT_HOME

if [ $(uname -s | grep -c CYGWIN) -gt 0 ]; then
	echo "WARN: running in CYGWIN environment"
	CPBOTBERT=`cygpath -wp $LIN_CPBOTBERT`
	DIR_PROPERTIES=`cygpath -wp $BOTBERT_HOME`
else
	CPBOTBERT=$LIN_CPBOTBERT
fi

APP_MAIN=BotListScanFeeds 
echo "BotBert Classpath=${CPBOTBERT} Main=${APP_MAIN}"
echo "-----------------------"

"$JAVA" -Xmx32M -classpath $CPBOTBERT $APP_MAIN -f $DIR_PROPERTIES $@ &
# Write the process id
echo $! > $BOTBERT_HOME/bin/botbert.pid


# End of Script --
