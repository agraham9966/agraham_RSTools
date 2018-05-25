import sys 
import subprocess
from util import get_files_in_folder

directory = sys.argv[1]
for i in get_files_in_folder(directory):
	if i.endswith('.tif'):
		
		outfile = i.replace('.tif', '-%d.tif')
		
		args = [
			'convert',
			i,
			outfile
		]
		
		subprocess.call(args, shell=True)
		