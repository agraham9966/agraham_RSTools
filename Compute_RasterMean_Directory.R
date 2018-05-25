rm(list=ls())
##if you don't have packages installed, insert package name below in quotes 
library(rgdal)
library(raster)

x<- stack(list.files(pattern = "tif$"))

( x.stats <- t(data.frame(x.mean=cellStats(x, "mean"))) ) ## gets mean of each raster 
( x.stats <- rbind(x.stats, t(data.frame(x.sd=cellStats(x, "sd")))) ) ##puts means into dataframe
finaldf<- as.data.frame(t(x.stats))

write.csv(x.stats, file = "cam_200055_sens2.csv")
##test for xmls
xml<-list.files(pattern="*.xml")
xmlToList(xml)
writeRaster(x, "test.tif", datatype = 'INT2U', options=c("COMPRESS=NONE", "TFW=YES"))
