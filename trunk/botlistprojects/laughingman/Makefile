#**********************************************************
# Build the .beam erlang VM files
# Makefile for irc bot (based on orbitz bot)
# Based on orbitz
#**********************************************************

TOPDIR := $(shell pwd)
DATE   = $(shell date +%Y%m%d)

APPLICATION = laughingman
VERSION     = 0.0.1

ESRC  = ./src
EBIN  = ./ebin

IRC_LIB     = ./orbirclib
IRC_LIB_SRC = $(IRC_LIB)/src

TEST_DIR     = ./test/erlang
TEST_DIR_SRC = $(TEST_DIR)/src

ERLC  = erlc
ERL   = erl

OPT   = -W
INC   = $(IRC_LIB)/inc

SED   = $(shell which sed)

TMP         = $(wildcard *~) $(wildcard src/*~) $(wildcard inc/*~)
INC_FILES   = $(wildcard $(INC)/*.hrl)
SRC         = $(wildcard $(ESRC)/*.erl)
CONFFILES   = conf/config.xml $(wildcard conf/*fortune)

TARGET      = $(addsuffix .beam, $(basename \
                 $(addprefix $(EBIN)/, $(notdir $(SRC)))))

LIB_TARGET_OBJS = $(EBIN)/bot_app.beam \
	 $(EBIN)/bot_manager.beam           \
	 $(EBIN)/bot_supervisor.beam        \
	 $(EBIN)/dcc.beam                   \
	 $(EBIN)/dict_proc.beam             \
	 $(EBIN)/factoid_file_gen.beam      \
	 $(EBIN)/irc_bot.beam               \
	 $(EBIN)/irc_lib.beam               \
	 $(EBIN)/irc_lookup.beam            \
	 $(EBIN)/msg_dispatch.beam          \
	 $(EBIN)/p1_db.beam                 \
	 $(EBIN)/plugin_manager.beam        \
	 $(EBIN)/rec_convert.beam

TEST_OBJS = $(EBIN)/eunit_examples.beam \
	$(EBIN)/simple_irc_lib.beam

${APPLICATION}: $(TARGET) $(LIB_TARGET_OBJS) $(TEST_OBJS)

all: clean ${APPLICATION}

clean:
	-rm -f $(TARGET) $(TMP)
	-rm -f ebin/*.beam

ebin/%.beam: $(IRC_LIB_SRC)/%.erl
	$(ERLC) $(OPT) -I $(INC) -o ebin $<

ebin/%.beam: $(TEST_DIR_SRC)/%.erl
	$(ERLC) $(OPT) -I $(INC) -o ebin $<

ebin/%.beam: $(ESRC)/%.erl
	$(ERLC) $(OPT) -I $(INC) -o ebin $<

# Start the erl emulator process with the social stats module
# Also -s erlang halt
tests: $(APPLICATION)
	$(ERL) -noshell -pa $(TOPDIR)/ebin -s laughingman test -s erlang halt

# End of the file 
