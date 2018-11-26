rm(list=ls())
install.packages("cran")
library(rgdal)
library(raster)

##Takes all dark frame images from within working directory and stacks them into a single object 
darkrastdat<- list.files(pattern="*.tif")
darkstack<- stack(darkrastdat)
##computes the mean of all dark layers/pixels within the object, omits no-data values 
masterdark <- mean(darkstack, na.rm=TRUE)

##loads each light frame into an object and subtracts master dark 
lightrastdat<- list.files()
corrected_rasters = lapply(
  lightrastdat, 
  function(file){
    r = raster(file)
    return(r - masterdark)
  }
)

# computes mean of all rasters to compute master flat

corrected_mean = do.call(mean, corrected_rasters)

##temporary light stack script (basic mean of light frames) skysquirrel method
lightstackFF<-list.files()
stacklights<-stack(lightstackFF)
avglight<- mean(stacklights, na.rm=TRUE)
mean<- summary(values(avglight)
summary(mean)
rescaled1<- avglight/mean[4]
rescaled2<- rescaled1*1024

mean<- summary(values(avglight))

##writes master flat as 16-bit into original working directory
writeRaster(rescaled2, filename= "rescaled.tif", datatype='INT2U', overwrite=TRUE)
