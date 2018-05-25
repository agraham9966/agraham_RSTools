rm(list=ls())
library(rgdal)
library(raster)

                                      ##Split Raster Layers and Reorder##
# Create RasterLayer object
r <- stack('Mosaic_test.tif')

# Write the RasterLayer to disk for each layer 
writeRaster(r, filename="channel.tif", bylayer= TRUE, datatype='INT2U', overwrite=TRUE)

##Stack Multiple Raster Layers - assumes original order is: 676, 636, 550, 850, 450, 610, 694, 900
fs_8channel<- c("channel_5.tif","channel_3.tif","channel_6.tif","channel_2.tif","channel_1.tif","channel_7.tif","channel_4.tif","channel_8.tif" )

s <- raster::stack(fs_8channel)
writeRaster(s, "reordered3.tif", datatype = 'INT2U', options=c("COMPRESS=NONE", "TFW=YES"))




