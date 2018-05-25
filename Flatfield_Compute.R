rm(list=ls())
##if you don't have packages installed, insert package name below in quotes 
install.packages("XML")
library(rgdal)
library(raster)
library(XML)
setwd("")


##Takes all files within workind directory and stacks them into a single object.Names are according to specific band order
## e.g. lightstack_650_636_550 means B0 is either 650, 636, or 550
lightstack_650_636_550<- stack(list.files(pattern = "*_0.tif"))
lightstack_532_676<- stack(list.files(pattern ="*_1.tif"))
lightstack_450_900<- stack(list.files(pattern ="*_2.tif"))
lightstack_850_975<- stack(list.files(pattern ="*_3.tif"))

##computes the mean of all layers within the object, omits no-data values 
masterflat_650_636_550 <- mean(lightstack_650_636_550, na.rm=TRUE)
masterflat_532_676 <- mean(lightstack_532_676, na.rm=TRUE)
masterflat_450_900 <- mean(lightstack_450_900, na.rm=TRUE)
masterflat_850_975 <- mean(lightstack_850_975, na.rm=TRUE)



##writes master flat as 16-bit into original working directory- save band as 'band#'.tif, i.e. (450.tif)

## FLATS FOR 650, 636, OR 550
writeRaster(masterflat_650_636_550, filename= "550.tif", datatype='INT2U', overwrite=TRUE)

## FLATS FOR 532 OR 676
writeRaster(masterflat_532_676, filename= "676.tif", datatype='INT2U', overwrite=TRUE)

## FLATS FOR 450 OR 900
writeRaster(masterflat_450_900, filename= "900.tif", datatype='INT2U', overwrite=TRUE)

## FLATS FOR 850 OR 975
writeRaster(masterflat_850_975, filename= "975.tif", datatype='INT2U', overwrite=TRUE)
