##
## Client to generate basic spring bean components
## used throughout this application
##
## Run with python(cpython)
## 

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

from beangen import BeanGen



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
                            
def process_config(ini):
    '''
    Process the Configuration file 
     Default sections:
     System
     Table
     Fields
    '''
    if ini.System and ini.Table and ini.Fields:
        print "Valid configuration, continue"

        bean = ini.System['bean_package']
        dao = ini.System['dao_package']
        base = ini.System['base_package']
        table = ini.Table['table_name']

        dfields = {}
        for node in ini.Fields.keys():
            fkey = node.strip()
            dfields[fkey] = ini.Fields[node].strip()
            
        beangen = BeanGen()
        beangen.bean_package = bean.strip()
        beangen.dao_package = dao.strip()
        beangen.base_package = base.strip()
        beangen.table_name = table.strip()
        beangen.fields = dfields
        beangen.generateClassNames()
        beangen.generateClassFiles()
        beangen.toString()
        
    else:
        print "** ERR: Invalid configuration, current ini="
        print ini               
    
def main():
    
    import getopt
    print "Bean Gen Client:"
    
    sysargs = sys.argv
    if len(sysargs) != 3:
        print "usage: -f [INPUT FILE]"
        return
    
    optlist, args = getopt.getopt(sysargs[1:], "f:")
    print "Args=", optlist, args
    print "usage: -f [INPUT FILE]"
    
    for (option, value) in optlist:  
        if option == '-f':  
            inpath = value

    # Setup the output directory
    setup_output_dir()
    
    ini = load_script(inpath)
    process_config(ini)
            
    # Load the INI configuration file
    print "Done."

if __name__ == '__main__':
    main()

# End of File


