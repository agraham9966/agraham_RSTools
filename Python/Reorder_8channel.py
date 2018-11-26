import sys 
import os 
import subprocess

##Assumes the original band ordering of the mosaic is 676, 636, 550, 850, 450, 610, 694, 900. 
##Reorders bands sequentially 
dir1 = sys.argv[1]
path, filename = os.path.split(dir1)
outfilename = path + '/Reordered.tif'


def reorderbands(Mosaic, outfilename):
    try:
        subprocess.check_call(['gdal_translate', '-b', '5', '-b', '3', '-b', '6', '-b', '2', '-b', '1', '-b', '7', '-b', '4', '-b', '8', '-of', 'GTiff', Mosaic, outfilename], shell=True)
        return outfilename
    
    except:
        return None

reorderbands(dir1, outfilename)