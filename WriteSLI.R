rm(list=ls())
##write envi SLI file 
library(RStoolbox)
##reads txt file with no header. Column1= wavelength, Column2 = DN
#SLI<- read.delim("FD_2017.txt", header = FALSE)
#as.data.frame(SLI)
#writeSLI(sli, "C:\\Users\\SST\\Downloads\\SLIwrite\\SLI.sli", wavl.units = "Nanometers", scaleF = 1, mode ="bin")

##Read SLI and Rescale 

sli<-readSLI("SF04_MEA_10122017_10pix_SLI.sli")
names(sli)<- c("wavelength", "Min:2", "Mean-StdDev:3", "Mean:4", "Mean+StdDev:5", "Max:6")
sli$`Min:2`<-(sli$`Min:2`*10000)/65535
sli$`Mean-StdDev:3`<-(sli$`Mean-StdDev:3`*10000)/65535
sli$`Mean:4`<-(sli$`Mean:4`*10000)/65535
sli$`Mean+StdDev:5`<-(sli$`Mean+StdDev:5`*10000)/65535
sli$`Max:6`<-(sli$`Max:6`*10000)/65535

writeSLI(sli, "C:\\Users\\SST\\Desktop\\SLI_rescale.sli", wavl.units = "Nanometers", scaleF = 1, mode ="bin")
