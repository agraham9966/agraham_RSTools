import sys 
import os 
import cv2
from osgeo import gdal, osr, ogr
from Research_Tools import create_gdal_obj

dir1 = sys.argv[1]
dir2 = sys.argv[2]

def MatchRasterProjection(MasterMosaic, SlaveMosaic): 

    path, filename = os.path.split(SlaveMosaic)
    filename = os.path.splitext(filename)[0]
    newfilename = 'reproj_%s.tif' % filename 
    outfilename = os.path.join(path, newfilename)
    MasterRas = gdal.Open(MasterMosaic) 
    SlaveRas = gdal.Open(SlaveMosaic)
    MasterBand = MasterRas.GetRasterBand(1)
    cols = MasterRas.RasterXSize
    rows = MasterRas.RasterYSize
    MasterArray = MasterBand.ReadAsArray(0, 0, cols, rows)
    SlaveBand = SlaveRas.GetRasterBand(1)
    SlaveArray = SlaveBand.ReadAsArray(0, 0, cols, rows)
    geotransform = MasterRas.GetGeoTransform()
    spatialreference = MasterRas.GetProjection()
    srs=osr.SpatialReference(wkt=spatialreference)
    check = srs.GetAttrValue('projcs')
    print "Master Project CS", check
    dataset = Research_Tools.create_gdal_obj(outfilename, SlaveArray, 'GTiff', geotransform, spatialreference)
	
    return dataset
	
MatchRasterProjection(dir1, dir2)
