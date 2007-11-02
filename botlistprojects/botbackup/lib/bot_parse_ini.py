##================================================
## Run with python(cpython)
##================================================

'''
 Example:
 *****************************
 print "ini['Startup']['modemid'] =", ini['Startup']['modemid'] 
 print "ini.Startup =", ini.Startup
 print "ini.Startup.modemid =", ini.Startup.modemid
 print "ini['Startup']['modemid'] =", ini['Startup']['modemid']
 *****************************
''' 
import sys
import os
import pprint
from pyparsing.pyparsing import \
     Literal, Word, ZeroOrMore, Group, Dict, Optional, \
     printables, ParseException, restOfLine

#-------------------------------------------------
# bot parse ini bean class
#-------------------------------------------------
class BotbackupBean:
	def __init__(self):
		self.application_name = "rsync"
		self.default_args = "-avz"
		self.priv_key_file = "/home/USER/sys/backup/FILE_KY"
		self.username = "user"
		self.hostname = "austin"
		
	def __str__(self):
		return ''.join([ "\nBeanGen Definition:",
						 "\n\tapplication_name=", self.application_name,
						 "\n\thostname=", self.hostname ])
	
#-------------------------------------------------

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
        inibnf = Dict( ZeroOrMore( Group( sectionDef + Dict( ZeroOrMore( Group( keyDef ) ) ) ) ) )        
        inibnf.ignore( comment )
        
    return inibnf

def load_script( strng ):
    try:
        iniFile = file(strng)
        iniData = "".join( iniFile.readlines() )
        bnf = inifile_BNF()
        tokens = bnf.parseString( iniData )
    except ParseException, err:
        print "********* Err *************"
        print err.line
        print " "*(err.column-1) + "^"
        print err
    
    iniFile.close()
    print
    return tokens

def setup_output_dir():
    '''
    Check that the output directory exists
    '''
    if not os.path.exists('./output'):
        print "Warning: output directory does not exist, creating."
        os.mkdir("./output")
		
#-------------------------------------------------
# bot parse ini
#-------------------------------------------------
                            
def process_config(ini):
	'''
	Process the Configuration file
	Default sections:
	+ System
	+ Table
	+ Fields
	'''
	bean = BotbackupBean()
	try:
		if ini.RsyncConfig:
			print "INFO: Valid configuration, continue"
			a1 = ini.RsyncConfig[0][1]
			a2 = ini.RsyncConfig[1][1]
			a3 = ini.RsyncConfig[2][1]
			a4 = ini.RsyncConfig[3][1]
			a5 = ini.RsyncConfig[4][1]
						
			bean.application_name = a1.strip()
			bean.default_args = a2.strip()
			bean.priv_key_file = a3.strip()
			bean.username = a4.strip()
			bean.hostname = a5.strip()
		else:
			print "** ERR: Invalid configuration, current ini="
			print ini
	finally:
		return bean
		
# End of File
