import sys 
import os 
from osgeo import gdal, osr, ogr
import subprocess
##resamples to 1.2m. Input data needs to be in UTM projection. 
dir1 = sys.argv[1]
##checks and prints input raster projection 
checkras = gdal.Open(dir1)
prj = checkras.GetProjection()
srs=osr.SpatialReference(wkt=prj)
check = srs.GetAttrValue('projcs')
print "Project CS", check
if check == "None":
    print "Not Projected" 
    exit()
##get folder path 
path, filename = os.path.split(dir1)
outfilename = path + '/Resampled.tif'
##define resample parameter
OutputResolution = raw_input("Enter desired resolution in metres: ")
ResampleMethod = raw_input("Enter resample method (nearest,bilinear, cubic, average.): ")


def rastresample(Mosaic, outfilename):
    try:
        subprocess.check_call(['gdal_translate', '-tr', OutputResolution, OutputResolution, '-r', ResampleMethod, Mosaic, outfilename], shell=True)
        return outfilename
    
    except:
        return None
		
rastresample(dir1, outfilename)