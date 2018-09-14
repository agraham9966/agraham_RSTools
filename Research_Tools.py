import sys 
import os 
import subprocess
from osgeo import gdal 
from util import get_files_in_folder

##Splits multipage tifs within directory 
def SplitMultipageTiff(directory): 
    for i in get_files_in_folder(directory):
	    if i.endswith('.tif'):
		
		    outfile = i.replace('.tif', '-%d.tif')
		
		    args = [
			    'convert',
			    i,
			    outfile
		    ]
		
		subprocess.call(args, shell=True)

##reorders bands 	
def reorderbands(Mosaic, outfilename):
    try:
        subprocess.check_call(['gdal_translate', '-b', '5', '-b', '3', '-b', '6', '-b', '2', '-b', '1', '-b', '7', '-b', '4', '-b', '8', '-of', 'GTiff', Mosaic, outfilename], shell=True)
        return outfilename
    
    except:
        return None

##Writes ENVI header and BSQ 		
def writeENVIHDR(Mosaic, outfilename): 
    gtif = gdal.Open(Mosaic)
    myarray = gtif.GetRasterBand(1).ReadAsArray()
    driver = gdal.GetDriverByName('ENVI')
    colsa = gtif.RasterXSize
    rowsa = gtif.RasterYSize
    destination = driver.Create(outfilename, colsa, rowsa, 8, gdal.GDT_UInt16)
    destination.SetMetadataItem('wavelength','{450.000000, 550.000000, 610.000000, 636.000000, 676.000000, 694.000000,850.000000, 900.000000}', 'ENVI')
    destination.SetMetadataItem('wavelength units','Nanometers', 'ENVI')
    rb = destination.GetRasterBand(1)
    rb.WriteArray(myarray)
    return myarray 
	
no_data = -9999
	
def create_gdal_obj(filename, raster, dtype='GTiff', geotransform = None, wkt = None, precision=gdal.GDT_UInt16):
    shape = raster.shape
    bands = 1

    # Check if raster is single or multi channel
    if len(shape) == 2:
        rows, cols = shape
    elif len(shape) == 3:
        bands, rows, cols = shape

    driver = gdal.GetDriverByName(dtype)
    dest = driver.Create(filename, cols, rows, bands, precision)

    if geotransform is not None:
        dest.SetGeoTransform(geotransform)

    if wkt is not None:
        dest.SetProjection(wkt)

    if bands > 1:
        for i, band in enumerate(raster):
            dest.GetRasterBand(i+1).WriteArray(band)
            dest.GetRasterBand(i+1).ComputeStatistics(0)
            dest.GetRasterBand(i+1).SetNoDataValue(no_data)
    else:
        dest.GetRasterBand(1).WriteArray(raster)
        dest.GetRasterBand(1).SetNoDataValue(no_data)

    return dest
