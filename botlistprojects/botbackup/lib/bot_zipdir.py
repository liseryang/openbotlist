"""
 Zip directory
"""
from zipfile import ZipFile, ZIP_DEFLATED
import os
import sys

def zip_path(path, archive):
	paths = os.listdir(path)
	for p in paths:
		p = os.path.join(path, p) # Make the path relative
		if os.path.isdir(p): # Recursive case
			zip_path(p, archive)
		else:
			archive.write(p)
	return

def get_basename(curpath):
	basename = os.path.basename(curpath)
	return basename

def create_zip_file(path, archname):
    # Create a ZipFile Object primed to write
	# "a" to append, "r" to read
    archive = ZipFile(archname, "w", ZIP_DEFLATED)
    # Recurse or not, depending on what path is
    if os.path.isdir(path):
        zip_path(path, archive)
    else:
        archive.write(path)
    archive.close()
    return "Compression of \"" + path + "\" was successful"

if __name__ == '__main__':
	print "zipping file"
	result = create_zip_file(
		"/home/bbrown/sys/backup/example",
		"/home/bbrown/sys/backup/%s.zip" % get_basename("/home/bbrown/sys/backup/example"))
	print result

