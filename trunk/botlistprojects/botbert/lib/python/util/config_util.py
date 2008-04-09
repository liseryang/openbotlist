'''
# Author: Berlin Brown
# Date: 4/10/2008
#
# Copyright (c) 2007, Botnode.com (Berlin Brown)
# See LICENSE.BOTLIST for the most recent license updates.
#
# http://www.opensource.org/licenses/bsd-license.php
# 
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, 
# are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright notice, 
#    this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, 
#    this list of conditions and the following disclaimer in the documentation 
#    and/or other materials provided with the distribution.
#    * Neither the name of the Newspiritcompany.com (Berlin Brown) nor 
#    the names of its contributors may be used to endorse or promote 
#    products derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
'''

__author__ = "Berlin Brown"
__version__ = "0.1"

import sys
from pyparsing.pyparsing import \
     Literal, Word, ZeroOrMore, Group, Dict, Optional, \
     printables, ParseException, restOfLine

# Global value, store the filename
conf_filename = "conf/remote_config.ini"

inibnf = None
def inifile_BNF():
    
    global inibnf    
    if not inibnf:
        
        # punctuation
        lbrack = Literal("[").suppress()
        rbrack = Literal("]").suppress()
        equals = Literal("=").suppress()
        semi   = Literal(";")
        
        comment = semi + Optional( restOfLine )
        
        nonrbrack = "".join( [ c for c in printables if c != "]" ] ) + " \t"
        nonequals = "".join( [ c for c in printables if c != "=" ] ) + " \t"
        
        sectionDef = lbrack + Word( nonrbrack ) + rbrack
        keyDef = ~lbrack + Word( nonequals ) + equals + restOfLine
        
        # using Dict will allow retrieval of named data fields as attributes of the parsed results
        inibnf = Dict(ZeroOrMore(Group(sectionDef + Dict( ZeroOrMore(Group(keyDef))))))
        inibnf.ignore(comment)
        
    return inibnf

def load_script( strng ):
    try:
        iniFile = file(strng)
        iniData = "".join(iniFile.readlines())
        bnf = inifile_BNF()
        tokens = bnf.parseString(iniData)
    except ParseException, err:
        print "********* Err *************"
        print err.line
        print " "*(err.column-1) + "^"
        print err    
    iniFile.close()
    return tokens

class ConfigType:
    def __init__(self):
        self.username = "USER"
        self.password = "PASSWORD"
        self.database = "openbotlist_test"
        self.hostname = "localhost"
        
def process_config(ini):
    '''
    ------------------------------------
    Process the Configuration file 
     Default sections:
     DatabaseConnection

     Usage:
     ini = conf.load_script(self.filename)
     conf_type = conf.process_config(ini)  
    ------------------------------------'''
    conf_type = ConfigType()
    if ini.DatabaseConnection:
        print "INFO: Valid configuration found."
        try:
            # TODO: Normally we chould use the hash key lookup?         
            conf_type.username = ini.DatabaseConnection[0][1].strip()
            conf_type.password = ini.DatabaseConnection[1][1].strip()
            conf_type.database = ini.DatabaseConnection[2][1].strip()
            conf_type.hostname = ini.DatabaseConnection[3][1].strip()
        except Exception, e:
            print "ERR: parse_config(), [%s]" % (e)
    else:
        print "ERR: Invalid configuration, current ini="
        print ini
        
    return conf_type

def set_conf_filename(filename):
    global conf_filename
    conf_filename = filename

def get_parse_config():
    '''Public utility function, use to return the config type with the
    data loaded from the INI config file'''
    global conf_filename
    ini = load_script(conf_filename)
    conf_type = process_config(ini)
    return conf_type
    
# End of the script
