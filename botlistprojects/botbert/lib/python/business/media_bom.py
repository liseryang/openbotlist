"""
 Berlin Brown
 6/20/2007
 
 media_bom.py
 
 media business object model
"""
__author__ = "Berlin Brown"
__version__ = "0.1"

import MySQLdb
from botlist_business_object import BotlistBusinessObject

SQL_PREFIX = "'"
SQL_SUFFIX = "', "
SQL_EMPTY = "'', "

MAX_FEEDS_CREATE = 10

#--------------------------------------
class MediaHandler(BotlistBusinessObject):    
    
    def createActiveMedia(self):
        """ Delete existing media feeds and activate a new set"""
        try:
            cursor = self.conn.cursor()            
            toggle_media_type = False
            
            # Delete existing records from active feed set
            res = cursor.execute("delete from active_media_feeds")
            
            # Iterate and create new records
            for i in range(0, MAX_FEEDS_CREATE):
                sql_set = []                
                toggle_media_type = not toggle_media_type
                # 'H' (home) OR 'B' botverse
                media_type = toggle_media_type and 'H' or 'B'
                sql_set.append("insert into active_media_feeds ")
                sql_set.append("    values((select id from media_feeds order by RAND() limit 1),'%s', NOW());")
                sql_str = ''.join(sql_set)
                res = cursor.execute(sql_str % media_type)                
                
            cursor.close()
        except MySQLdb.OperationalError, message:
            errorMessage = "ERR %d:\n%s" % (message[0], message[1])
            return
        
    def createCursor(self, media_obj):
        try:
            cursor = self.conn.cursor()
            sql_set = []
            sql_set.append("insert into ")
            sql_set.append("media_feeds ")
            sql_set.append("(image_filename, media_url, ")
            sql_set.append("image_thumbnail, media_title, ")
            sql_set.append("media_descr, media_type, ")
            sql_set.append("author, rating, rating_count, ")
            sql_set.append("views, keywords, orginal_imgurl, ")
            sql_set.append("process_count, created_on) ")
        
            # Set the values
            sql_set.append("VALUES(")
            sql_set.append(SQL_EMPTY)  # filename        
            sql_set.append(SQL_PREFIX + media_obj.url + SQL_SUFFIX)       # media url
            sql_set.append(SQL_PREFIX + media_obj.thumbnail + SQL_SUFFIX) # thumbnail
            sql_set.append(SQL_PREFIX + media_obj.title + SQL_SUFFIX)     # title
            sql_set.append(SQL_PREFIX + media_obj.descr + SQL_SUFFIX)     # descr
            sql_set.append("'V', ")             # media type
            sql_set.append(SQL_PREFIX + media_obj.author + SQL_SUFFIX)    # author
            
            sql_set.append(media_obj.rating + ", ")       # rating
            sql_set.append(media_obj.rating_ct + ", ")    # rating count
            sql_set.append(media_obj.views + ", ")        # views
            
            sql_set.append(SQL_PREFIX + media_obj.keywords + SQL_SUFFIX)  # keywords
            sql_set.append(SQL_EMPTY)           # orginal img url
            sql_set.append("0, ")               # process count            
            sql_set.append("NOW())")
             
            sql_str = ''.join(sql_set)
            cursor.execute(sql_str)
            cursor.close()
        except MySQLdb.OperationalError, message:
            errorMessage = "ERR %d:\n%s" % (message[0], message[1])
            return
 
# End of file