#**********************************************************
# Build the .beam erlang VM files
# Makefile for irc bot (based on manderlbrot)
# Based on manderlbot - 0.9.2
#**********************************************************

OPT   = -W
INC   = ./inc
ERLC  = erlc
ERL   = erl
SED   = $(shell which sed)

ESRC  = ./src
EBIN  = ./ebin

DESTDIR=.
RAW_INSTALL_DIR = .
ERLANG_INSTALL_DIR = $(DESTDIR)/$(RAW_INSTALL_DIR)/lib

# (formerly manderlbot)
APPLICATION = ircbot
VERSION     = 0.0.1

BINDIR      = $(DESTDIR)/usr/bin
CONFDIR     = $(DESTDIR)/etc/${APPLICATION}
LOGFILE     = $(DESTDIR)/var/log/${APPLICATION}.log

TMP         = $(wildcard *~) $(wildcard src/*~) $(wildcard inc/*~)
INC_FILES   = $(wildcard $(INC)/*.hrl)
SRC         = $(wildcard $(ESRC)/*.erl)
CONFFILES   = conf/config.xml $(wildcard conf/*fortune)

TARGET      = $(addsuffix .beam, $(basename \
                 $(addprefix $(EBIN)/, $(notdir $(SRC)))))
EMAKE       = $(addsuffix \'., $(addprefix \'../, $(SRC)))

SRC_APPFILES   = $(ESRC)/$(APPLICATION).app.src $(ESRC)/$(APPLICATION).rel.src
TGT_APPFILES_E = $(EBIN)/$(APPLICATION).app
TGT_APPFILES_P = priv/$(APPLICATION)*

SCRIPT   = $(BINDIR)/${APPLICATION}
BUILD_OPTIONS =	'[{systools, [{variables,[{"ROOT","$(RAW_INSTALL_DIR)"}]}]}, \
	{sh_script, none}, {report, verbose}, {app_vsn, "$(VERSION)"}, \
        {make_app, true }, {make_rel, true}].'
BUILD_OPTIONS_FILE = ./BUILD_OPTIONS 

.PHONY: doc

${APPLICATION}: $(TARGET)

all: clean ${APPLICATION}

clean:
	-cd priv && rm -f $(shell ls priv | grep -v builder\.erl) && cd ..
	-rm -f $(TARGET) $(TMP) $(BUILD_OPTIONS_FILE) builder.beam
	-rm -f $(TGT_APPFILES)
	-rm -f ebin/*
	-rm -f ${APPLICATION}.sh
	-make -C doc clean

build: ${APPLICATION} builder.beam $(SRC_APPFILES)
# Use builder to make boot file
	mkdir -p temp
	ln -sf `pwd` temp/$(APPLICATION)-$(VERSION)
	(cd temp/$(APPLICATION)-$(VERSION) \
	 && echo $(BUILD_OPTIONS) > $(BUILD_OPTIONS_FILE) \
	 && erl -s builder go -s init stop \
	)
	rm -rf temp

release:
	rm -fr $(APPLICATION)-$(VERSION)
	mkdir -p $(APPLICATION)-$(VERSION)
	tar zcf tmp.tgz $(SRC) $(SRC_APPFILES) $(INC_FILES) \
		doc/*.lyx doc/Makefile doc/*.hva doc/*sgml \
		LICENSE README TODO $(CONFFILES) Makefile \
		priv/builder.erl ${APPLICATION}.sh.in bofh.fortune
	tar -C $(APPLICATION)-$(VERSION) -zxf tmp.tgz
	mkdir $(APPLICATION)-$(VERSION)/ebin
	tar zvcf  $(APPLICATION)-$(VERSION).tar.gz $(APPLICATION)-$(VERSION)
	rm -fr $(APPLICATION)-$(VERSION)
	rm -fr tmp.tgz

builder.beam: priv/builder.erl 
	$(ERLC) $(OPT) -I $(INC) $<

ebin/%.beam: src/%.erl 
	$(ERLC) $(OPT) -I $(INC) -o ebin $<
