"""
 Berlin Brown
 10/10/2007
"""

class BotBackupRec:
	def __init__(self):
		self.backup_path = None
		self.oper = "rsync"
		self.path_mode = "z"
		self.comment = None

def validate_row_func(line):
	""" Simple function to validate row
	from common delimited file """
	n = len(line)
	coln = len(line.split("\t"))
	return (n >= 0) and (not line.startswith("#")) and (coln == 4)

def create_backup_bean(row):
	""" Separate the columns and create a bean from the data"""
	cols = [s.strip() for s in row.split("\t")]
	rec = BotBackupRec()
	rec.backup_path = cols[0]
	rec.oper = cols[1]
	rec.path_mode = cols[2]
	rec.comment = cols[3]
	return rec
	
def read_datafile(datafile):
	""" The data file contains a line by line
	file format for paths that shall be queued
	for backup"""
	all_lines = open(datafile, "r").readlines()
	valid_rows = filter(validate_row_func, all_lines)
	backup_recs = map(create_backup_bean, valid_rows)
	return backup_recs
