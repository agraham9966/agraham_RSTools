##reads tiff and writes envi raster and header file 
##uses closing segmentation function in skimage : http://scikit-image.org/docs/dev/api/skimage.morphology.html#skimage.morphology.closing
import numpy as np
import scipy 
from scipy import ndimage, misc 
import scipy.ndimage.filters as filters
import scipy.ndimage.morphology as morphology
from scipy.ndimage.filters import minimum_filter
from scipy.ndimage.filters import maximum_filter as maxf2D
from skimage.morphology import square, closing, h_maxima
from scipy.signal import argrelextrema
from osgeo import gdal
import disease_detect_util as dd_util 
import cv2
import sys 
import os


dir1 = sys.argv[1]
gtif1 = gdal.Open(dir1)
path, filename = os.path.split(dir1)
outfilename = path + '/Closed_extremawindow.tif'
img = cv2.imread(dir1, cv2.IMREAD_UNCHANGED)
geotransform = gtif1.GetGeoTransform()
spatialreference = gtif1.GetProjection()


closed = closing(img)

def detect_local_minima(arr):
    # https://stackoverflow.com/questions/3684484/peak-detection-in-a-2d-array/3689710#3689710
    """
    Takes an array and detects the troughs using the local maximum filter.
    Returns a boolean mask of the troughs (i.e. 1 when
    the pixel's value is the neighborhood maximum, 0 otherwise)
    """
    # define an connected neighborhood
    # http://www.scipy.org/doc/api_docs/SciPy.ndimage.morphology.html#generate_binary_structure
    neighborhood = morphology.generate_binary_structure(len(arr.shape),2)
    # apply the local minimum filter; all locations of minimum value 
    # in their neighborhood are set to 1
    # http://www.scipy.org/doc/api_docs/SciPy.ndimage.filters.html#minimum_filter
    local_min = (filters.minimum_filter(arr, footprint=neighborhood)==arr)
    # local_min is a mask that contains the peaks we are 
    # looking for, but also the background.
    # In order to isolate the peaks we must remove the background from the mask.
    # 
    # we create the mask of the background
    background = (arr==0)
    # 
    # a little technicality: we must erode the background in order to 
    # successfully subtract it from local_min, otherwise a line will 
    # appear along the background border (artifact of the local minimum filter)
    # http://www.scipy.org/doc/api_docs/SciPy.ndimage.morphology.html#binary_erosion
    eroded_background = morphology.binary_erosion(
        background, structure=neighborhood, border_value=1)
    # 
    # we obtain the final mask, containing only peaks, 
    # by removing the background from the local_min mask
    detected_minima = local_min ^ eroded_background
    return np.where(detected_minima)       
	

final = detect_local_minima(closed)

#N,M = (3, 3)
#P,Q = closed.shape

# Use 2D max filter and slice out elements not affected by boundary conditions
#maxs = maxf2D(closed, size=(M,N))
#max_Map_Out = maxs[M//2:(M//2)+P-M+1, N//2:(N//2)+Q-N+1]




dataset = dd_util.create_gdal_obj(outfilename, final, 'GTiff', geotransform, spatialreference)
