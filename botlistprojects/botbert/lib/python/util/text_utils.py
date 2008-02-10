"""
 Berlin Brown
 text_utils
 8/20/2007
"""

import sys

def shorten(str, max_len):
    """Shorten a given string to a smaller number of characters"""
    if str:
        if len(str) > max_len:            
            return str[0:max_len].strip()
        else:
            return str
        
# End of script