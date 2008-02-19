#**********************************************
# Makefile for erlang tasks
# based on Makefile template by Joe Armstrong
# 2/2/2008
#**********************************************

VERSION = 0.0
DATE = $(shell date +%Y%m%d)

TOPDIR := $(shell pwd)
LIB1   := ${TOPDIR}/www_tools
LIB2   := ${TOPDIR}/rfc4627

ERL = erl -boot start_bit

.SUFFIXES: .erl .beam .yrl

#**********************************************
# All target
#**********************************************
all: compile

#**********************************************
# erl files
#**********************************************

.erl.beam:
	erlc -W $<

.yrl.erl:
	erlc -W $<

#**********************************************
# set of modules
#**********************************************
MOD_OBJS = socialstats

SUB_DIRS:
	cd www_tools ; make
	cd rfc4627 ; make

#**********************************************
# compile and other targets
#**********************************************
compile: ${MOD_OBJS:%=%.beam} SUB_DIRS

# Start the erl emulator process with the social stats module
# Also -s erlang halt
run:
	erl -noshell -pa ${TOPDIR} ${LIB1} ${LIB2} -s socialstats start_social -s erlang halt

#**********************************************
# Clean
#**********************************************
clean:
	rm -rf *.beam erl_crash.dump
	cd www_tools ; make clean
	cd rfc4627 ; make clean
