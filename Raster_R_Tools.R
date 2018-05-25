rm(list=ls())
install.packages("rgdal")
library(rgdal)
library(raster)

##PROJECT RASTER 
# Create RasterLayer object
r <- stack('Mosaic_geo.tif')
# Define the Proj.4 spatial reference 
# http://spatialreference.org/ref/epsg/26915/proj4/
sr <- "+proj=utm +zone=19 +south +ellps=WGS84 +datum=WGS84 +units=m +no_defs" 

# Project Raster
projected_raster <- projectRaster(r, crs = sr)
?projectRaster
# Write the RasterLayer to disk (See datatype documentation for other formats)
writeRaster(projected_raster, filename="CoverCrop_Surface_proj.tif", datatype='FLT4S', overwrite=TRUE)

#rastershift 
r<- shift(r, x=-0.280, y= -0.670)
writeRaster(r, filename= "Mosaic_shift.tif", datatype='INT2U', overwrite=TRUE)
