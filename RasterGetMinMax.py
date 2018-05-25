import sys 
import os
from osgeo import gdal

dir1 = sys.argv[1]
gtif1 = gdal.Open(dir1)
srcband = gtif1.GetRasterBand(1)
srcband.SetNoDataValue(1)
##get stats 
stats = srcband.GetStatistics(True, True)

# Print the min, max, mean, stdev based on stats index
print "[ STATS ] =  Minimum=%.3f, Maximum=%.3f, Mean=%.3f, StdDev=%.3f" % (
    stats[0], stats[1], stats[2], stats[3])

