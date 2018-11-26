##Creates an angular field of view raster map for a lens- where each pixel corresponds to the angle at which light will enter to the sensor- from a flat plane. 
library(pracma)
library(raster)

##sensor's image dimensions 
xMax = 11608
yMax = 8708

##agl(altitude) in metres, gsd(ground sample distance) in metres
agl = 5486.4
gsd = 0.36053

##creates a vectorized 2d grid 
grid = meshgrid(1:xMax, 1:yMax)
xCentre = xMax/2 
yCentre = yMax/2

##assigns a unit number based on the distance from the centre of each axis 
xAbs = abs(grid$X - xCentre) 
yAbs = abs(grid$Y - yCentre) 

##computes the distance 
dist = sqrt(xAbs^2+yAbs^2)
distM = dist*gsd

##convert pixel units to angular degrees 
angleMap = 180*atan(distM/agl)/pi
r=raster(angleMap);plot(r)

##rescales to 1000 
finalmap = r * 1000

writeRaster(finalmap, "test.tif", datatype = 'INT2U', options=c("COMPRESS=NONE"))
