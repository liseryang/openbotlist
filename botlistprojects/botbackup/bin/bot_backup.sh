#!/bin/sh

#---------------------------------------
# Copyright 2006-2007 Newspiritcompany.com. All Rights Reserved.
#
# Backup system script
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

APP_MAIN=${TOP_DIR}/lib/bot_backup.py

# Use the first arg, for example 'sweep' 'findcategory'
echo "SCRIPT: running in directory=${TOP_DIR} operation=$1"
echo "-----------------------"
echo 

python $APP_MAIN $1 $DIR_PROPERTIES -i $DIR_PROPERTIES/conf/botbackup.ini &
# Write the process id after application launched
echo $! > $TOP_DIR/bin/bot_backup.pid

# End of Script --
