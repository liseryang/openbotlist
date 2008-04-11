'''
 Java to ABCL Lisp Code Generation.
 Date: 4/10/2008

 "All it takes is one bad day to reduce the sanest man alive to lunacy.
 That's how far the world is from where I am. Just one bad day." -- Alan Moore

 Python Regex Helpers:
 -----------------------------
 .: any character except a newline.
 +: one or more instances of a pattern
 ^: the boundary at the beginning of a character string
 ?: one or more instances of a pattern
 $: the boundary at the end of a character string
 *: zero or more instances of a pattern
 \: the indicator of an escape sequence
 []: indicates a set of characters for a single position in the regex
 |: used as an 'or' between two possible matches. 
 (): used to group regular expressions
 {}: used to specify parameters for the matching of the regular expression

 Special Sequences:
 Notes from: [1] http://www.amk.ca/python/howto/regex/
 -----------------------------
 \d Matches any decimal digit; this is equivalent to the class [0-9].
 \D Matches any non-digit character; this is equivalent to the class [^0-9].
 \s Matches any whitespace character; this is equivalent to the class [ \t\n\r\f\v].
 \S Matches any non-whitespace character; this is equivalent to the class [^ \t\n\r\f\v].
 \w Matches any alphanumeric character; this is equivalent to the class [a-zA-Z0-9_].
 \W Matches any non-alphanumeric character; this is equivalent to the class [^a-zA-Z0-9_].
 -------------------------------

 re.match("regex", subject) == re.search("\Aregex", subject)
'''
__author__ = "Berlin Brown"
__version__ = "0.1"

# Include the system and regex libraries
import sys
import re

PROP_FILE = "java_code.txt"

SYS_TOKENS = [
    ('@END_EXPR_', "" ),
    ('@TRUE_EXPR_', "" ),
    ('@DOT_', "." ),
    ('@LEFT_PAREN_', "(" ),
    ('@RIGHT_PAREN_', ")" ),
    ('@ASSIGN_', "=" ),
]

def cleanup_remove_tokens(line):
    reuse_line = line
    for fst_val, snd_val in SYS_TOKENS:
        reuse_line = re.sub(fst_val, snd_val, reuse_line)
    return reuse_line

def has_starts_java(line):
    ''' Does the line start with a specific java tag'''
    #check_none = re.match("^import.*\$", line)
    check_none = re.match("(package)", line)
    if check_none is not None:
        return True

def codegen_java_line_clean(line):
    ''' Remove java characters we are not interested in'''
    p = re.compile('(\{|\}|private|void|static|final|class|public|try|catch)')
    try:
        line_strip = line.strip()
        re_line = p.sub('', line_strip)
        return re_line
    except:
        pass
    return line

def codegen_clean_all(line):    
    java_clean = codegen_java_line_clean(line)
    if has_starts_java(line) is not None:
        return None
    if java_clean.strip() is not None:
        return java_clean.strip()
    return None

def codegen_lines(all_lines):
    after_lines = []
    for line in all_lines:            
        after_line = codegen_clean_all(line)
        if (after_line is not None) and (len(after_line) > 0):
            after_lines.append(after_line)
    return after_lines

def codegen_java_parse(line):
    ''' Convert the java syntax into valid parsable tokens'''
    re_line = re.sub('\;',   '@END_EXPR_', line)
    re_line = re.sub('true', '@TRUE_EXPR_', re_line)
    re_line = re.sub('\.',   '@DOT_', re_line)
    re_line = re.sub('\(',   '@LEFT_PAREN_', re_line)
    re_line = re.sub('\)',   '@RIGHT_PAREN_', re_line)
    re_line = re.sub('\=',   '@ASSIGN_', re_line)
    re_line = re.sub('\s@ASSIGN_\snew\s', '@NEW_EXPR_', re_line)
    return re_line

def codegen_parse_new(line):
    #----------------------------------
    # Attempt to find expressions. object|DOT|LEFT_PAREN
    # Example: newMenuItem@NEW_EXPR_JMenuItem@LEFT_PAREN_"New"@RIGHT_PAREN_@END_EXPR_
    #                         var(1) assign  constr(3)          args(5)
    #-----------------------------------
    re_line = line
    p_assign_call = re.compile('^(.*)(@NEW_EXPR_)(.*)(@LEFT_PAREN_)(.*)(@RIGHT_PAREN_).*$')
    match_obj = p_assign_call.match(line)
    has_repl = False
    if match_obj is not None:
        try:
            obj = match_obj.group(1).strip()
            constructor = match_obj.group(3).strip()
            args = match_obj.group(5).strip()
            if (args is None) or len(args.strip()) == 0:
                args = ""
            res_line = "(let ((%s (jnew (jconstructor \"%s\" <ARG TYPES>) %s))))" % (obj, constructor, args)
            return res_line
        except Exception, e: 
            print "ERR: %s" % e
            pass
        
    return re_line

def last_import_classname(str):
    ''' If we assume that the user has an import statement with 'import abc.abc.Class',
    extract the class value.  Split based on the @DOT_ token delim, get the last'''
    # First, remove any expression tokens
    str = re.sub('@END_EXPR_', '', str)
    lst = str.split('@DOT_')
    if len(lst) > 1:
        lst_last_idx = len(lst) - 1
        return lst[lst_last_idx].lower()
    else:
        return lst[0].tolower()
        
def codegen_convert_lisp(all_lines):
    ''' First pass '''
    p_java_true = re.compile('@TRUE_EXPR_')
    #----------------------------------
    # Attempt to find expressions. object|DOT|LEFT_PAREN
    # INDEXES:                        1    2     3      4          5        6 
    #-----------------------------------
    p_func_call = re.compile('^(.*)(@DOT_)(.*)(@LEFT_PAREN_)(.*)(@RIGHT_PAREN_).*$')
    # Also handle import statements (regex: if 0 or more whitespace, check for import, 0 or more
    # whitespace, some package definition and after that, more characters.
    p_import_call = re.compile('^\s*(import)\s(.+)$')

    for line in all_lines:
        # Covert to the java code and expressions into valid tokens
        re_line = codegen_java_parse(line)
        re_line = p_java_true.sub('(make-immediate-object t :boolean)', re_line)
        match_obj = p_func_call.match(re_line)
        has_repl_method = False
        if match_obj is not None:
            try:
                obj = match_obj.group(1).strip()
                method_name = match_obj.group(3).strip()
                args = match_obj.group(5).strip()
                if (args is None) or len(args.strip()) == 0:
                    args = ""
                re_line = "(jcall (jmethod %s \"%s\" %s))" % (obj, method_name, args)
                has_repl_method = True
            except: pass
        
        match_obj = p_import_call.match(re_line)
        if match_obj is not None:
            try:
                pack_name = match_obj.group(2).strip()
                re_line = "(defconstant j-%s \"%s\")" % (last_import_classname(pack_name), pack_name)
            except Exception, e: 
                print e
                pass

        #---------------------
        # Convert all values of true to the lisp expression
        #---------------------
        if has_repl_method:
            re_line = cleanup_remove_tokens(re_line)
            #re_line = "<IGNORE>"
        else:
            re_line = cleanup_remove_tokens(codegen_parse_new(re_line))
            #re_line = "<IGNORE 2>"            
        print re_line
    
def main(args):
    f = None
    try:
        f = open(PROP_FILE, "r")
        all_lines = f.readlines()
        after_lines = codegen_lines(all_lines)
        codegen_convert_lisp(after_lines)
    finally:
        if f is not None:
            f.close()
    return 0

if __name__ == '__main__':
    res = main(sys.argv)
    sys.exit(res)
    print "Done"

# End of Script
