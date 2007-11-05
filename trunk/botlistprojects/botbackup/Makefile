###----------------------------------------------
### Makefile for OctaneMech
### 
### 9/20/2007
###----------------------------------------------

TOP_DIR := $(shell pwd)

###
### List of directories to be cleaned
### (edit accordingly to add to the list)
CLEAN_PROJ_DIRS = .     \
	lib                 \
	lib/pyparsing       \
	lib/rsync           \

###
### Target Clean
### 
clean:
	rm -vf *.pyc
	for ii in ${CLEAN_PROJ_DIRS} ; do	\
		echo "cleaning dir=${TOP_DIR}/$$ii/*.pyc" ;	\
		rm -vf ${TOP_DIR}/$$ii/*.pyc ; 	\
	done

###----------------------------------------------
### End of the Script
###----------------------------------------------