##reads tiff and writes envi raster and header file 
import sys 
import os
import subprocess
from osgeo import gdal

dir1 = sys.argv[1]
##get folder path 
path, filename = os.path.split(dir1)
Rast_outfilename = path + '/Mosaic_ENVI.bsq'
Reord_outfilename = path + '/Mosaic_ENVI.tif'

def reorderbands(Mosaic, outfilename):
    try:
        subprocess.check_call(['gdal_translate', '-b', '5', '-b', '3', '-b', '6', '-b', '2', '-b', '1', '-b', '7', '-b', '4', '-b', '8', '-of', 'GTiff', Mosaic, outfilename], shell=True)
        return outfilename
    
    except:
        return None


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
	
reorderbands(dir1, Reord_outfilename)
writeENVIHDR(dir1, Rast_outfilename)
	


##the written array is pushing band 1 from the input mosaic into destination.GetRasterBand(2) e.g. into specified channel 2 
##still needs to be fixed , however the hdr works with the input tiff as long as it has the same name