rm(list=ls())
##if you don't have packages installed, insert package name below in quotes 
install.packages("raster")
library(rgdal)
library(raster)
##all files must be within same directory 
##load variables of equation into R 
##equation: IC = [(IR-IB)*M]/(IF - IB)

##16-bit IF 
IF<- raster('694.tif')
IB<- 0
M<- 2843
IR<- raster('000091_sensor_2.tif')

#IF2<- IF^1.5

##calibration 

IC <-((IR-IB)*M)/((IF)-IB)

##writes master flat as 16-bit into original working directory- save band as 'band#'.tif, i.e. (450.tif)
writeRaster(IC, filename= "000091-694-rawFFCorrected.tif", datatype='INT2U', overwrite=TRUE)
