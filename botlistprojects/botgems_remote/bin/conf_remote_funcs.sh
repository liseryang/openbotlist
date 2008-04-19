#!/bin/sh

if [ -z "$JAVA_HOME"  ] ; then
 JAVA_HOME=/usr
fi

JAVA=$JAVA_HOME/bin/java

DIR_PROPERTIES=$BOTBERT_HOME

LIB1=$PROJECTS_HOME/botprojects_lib/java/lib/jruby.jar
LIB2=$PROJECTS_HOME/botprojects_lib/java/lib/sqlitejdbc-v043-nested.jar
LIB7=$PROJECTS_HOME/botprojects_lib/java/lib/botlist_amazons3.jar
LIB3=$BOTBERT_HOME/lib/botlistloadtest.jar
LIB4=$BOTBERT_HOME/lib/ibatis-2.3.0.677.jar
LIB5=$BOTBERT_HOME/lib/botlistbeans.jar
LIB6=$BOTBERT_HOME/lib/mysql-connector-java-5.0.3-bin.jar

if [ $(uname -s | grep -c CYGWIN) -gt 0 ]; then
	echo "WARN: running in CYGWIN environment"
	DIR_PROPERTIES=`cygpath -wp $BOTBERT_HOME`
fi

LIN_CPBOTBERT=".:$LIB1:$LIB2:$LIB3:$LIB4:$LIB5:$LIB6:$LIB7"
APP_MAIN=org.jruby.Main

# End of Script --
