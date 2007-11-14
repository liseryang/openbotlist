#!/bin/sh

#---------------------------------------
# Copyright 2006-2007 Newspiritcompany.com. All Rights Reserved.
#
# 10/30/2007
#---------------------------------------

# Depending on if we are running from pwd or not, determine
# proper location to change directory to.
# Through the use of 'dirname' and 'pwd', $0
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


TOP_DIR=$ABS_CONF
DIR_PROPERTIES=$ABS_CONF

APP_MAIN=SearchHelpDocs

## Set the classpath settings
LIB1=${TOP_DIR}/lib/sbaz.jar
LIB2=${TOP_DIR}/lib/scala-compiler.jar
LIB3=${TOP_DIR}/lib/scala-library.jar
LIB4=${TOP_DIR}/lib/lucene-core-2.2.0.jar
LIBAPP=${TOP_DIR}/build/classes

DOCS_CLASSPATH=.:$LIB1:$LIB2:$LIB3:$LIB4:$LIBAPP

## Overwrite, existing values if working with cygwin.
if [ $(uname -s | grep -c CYGWIN) -gt 0 ] ; then
	# Convert unix style paths to windows
	echo "WARN: running in CYGWIN environment"
	LIB1=`cygpath -wp ${LIB1}` 
	LIB2=`cygpath -wp ${LIB2}`
	LIB3=`cygpath -wp ${LIB3}`
	LIB4=`cygpath -wp ${LIB4}`
	LIBAPP=`cygpath -wp ${LIBAPP}`	
	DOCS_CLASSPATH=".;$LIB1;$LIB2;$LIB3;$LIB4;$LIBAPP"
	DIR_PROPERTIES=`cygpath -wp ${DIR_PROPERTIES}`	
fi


## Use the first arg, for example 'sweep' 'findcategory'
echo "SCRIPT: running in directory=${TOP_DIR}"
echo "-----------------------"
echo $DOCS_CLASSPATH 
echo 

java -classpath "$DOCS_CLASSPATH" $APP_MAIN ${DIR_PROPERTIES}/runtime/index_home/index

### End of Script
