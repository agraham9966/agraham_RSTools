import rasterio
import numpy as np
from glob import glob
import os
import sys

data_dir = sys.argv[1]
file_list = glob(os.path.join(data_dir, '*.tif'))

def read_file(file):
    with rasterio.open(file) as src:
        return(src.read(1))

# Read all data as a list of numpy arrays 
array_list = [read_file(x) for x in file_list]
# Perform averaging
array_out = np.mean(array_list, axis=0)

# Get metadata from one of the input files
with rasterio.open(file_list[0]) as src:
    meta = src.meta

meta.update(dtype=rasterio.float32)

# Write output file
with rasterio.open(data_dir, 'w', **meta) as dst:
    dst.write(array_out.astype(rasterio.float32), 1)